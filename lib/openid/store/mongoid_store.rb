require 'openid/store/interface'
require 'openid/store/nonce'
require 'moped/bson/binary'

require 'openid/store/models/nonce'
require 'openid/store/models/association'

module OpenID::Store
  class MongoidStore < OpenID::Store::Interface
    def self.cleanup
      cleanup_nonces
      cleanup_associations
    end

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

    def store_association(server_url, assoc)
      remove_association(server_url, assoc.handle)

      # BSON::Binary is used because secrets raise an exception
      # due to character encoding
      Association.create(:server_url => server_url,
                         :handle     => assoc.handle,
                         :secret     => Moped::BSON::Binary.new(:generic, assoc.secret),
                         :issued     => assoc.issued.to_i,
                         :lifetime   => assoc.lifetime,
                         :assoc_type => assoc.assoc_type)
    end

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
