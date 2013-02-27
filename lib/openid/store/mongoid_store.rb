require 'openid/store/interface'
require 'openid/store/nonce'
require 'moped/bson/binary'

require 'openid/store/models/nonce'
require 'openid/store/models/association'

# Module OpenID::Store is used for all OpenID Store types. Also helps distinguishes
# the Association/Nonce wrappers from OpenID::Association and OpenID::Nonce.
module OpenID::Store
  # OpenID Store class which uses Mongoid to store and access Association and Nonce data.
  class MongoidStore < OpenID::Store::Interface
    # Cleans up any expired Nonce and Association data
    # @note Not run as part of the normal process, must be run manually if desired.
    def self.cleanup
      cleanup_nonces
      cleanup_associations
    end

    # Gets the Association for the given server url and handle.
    # @param [String] server_url URL of the server making the request
    # @param handle The handle associated with the Association
    # @note Called internally by OpenID.
    def get_association(server_url, handle = nil)
      assns = query_associations(server_url, handle)

      assns.reverse.each do |assn|
        a = assn.from_record
        if a.expires_in == 0
          assn.destroy
        else
          return a
        end
      end if assns.any?

      return nil
    end

    # Stores an Association for the given server url and OpenID::Association.
    # @param [String] server_url URL of the server making the request
    # @param [OpenID::Association] assoc Object to use to create Association
    # @note Called internally by OpenID.
    def store_association(server_url, assoc)
      remove_association(server_url, assoc.handle)

      Association.create(:server_url => server_url,
                         :handle     => assoc.handle,
                         :secret     => Moped::BSON::Binary.new(:generic, assoc.secret),
                         :issued     => assoc.issued.to_i,
                         :lifetime   => assoc.lifetime,
                         :assoc_type => assoc.assoc_type)
    end

    # Creates a Nonce for the given information.
    # @param [String] server_url URL of the server making the request
    # @param timestamp Time the Nonce was created.
    # @param [String] salt Random string to uniquify Nonces. 
    # @return True if the given nonce has not been created before and the timestamp is valid, False otherwise.
    def use_nonce(server_url, timestamp, salt)
      return false if any_nonces?(server_url, timestamp, salt) || delta_beyond_skew?(timestamp)
      Nonce.create(:server_url => server_url, :timestamp => timestamp, :salt => salt)
      return true
    end

    private

    def query_associations(server_url, handle)
      if handle.blank?
        Association.where(:server_url => server_url)
      else
        Association.where(:server_url => server_url, :handle => handle)
      end
    end

    def remove_association(server_url, handle)
      Association.where(:server_url => server_url, :handle => handle).each do |assoc|
        assoc.destroy!
      end
    end

    def any_nonces?(server_url, timestamp, salt)
      Nonce.where(:server_url => server_url, :timestamp => timestamp, :salt => salt).any?
    end

    def delta_beyond_skew?(timestamp)
      (timestamp.to_i - Time.now.to_i).abs > OpenID::Nonce.skew
    end

    def self.cleanup_nonces
      now = Time.now.to_i
      Nonce.any_of({:timestamp.gt => now + OpenID::Nonce.skew}, {:timestamp.lt => now - OpenID::Nonce.skew}).delete
    end

    def self.cleanup_associations
      Association.for_js("(this.issued + this.lifetime) < ti", ti: Time.now.to_i).delete
    end
  end
end
