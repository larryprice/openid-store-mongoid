require 'mongoid'
require 'openid/association'

module OpenID::Store
  # Wrapper class for an OpenID::Association object.
  class Association
    include Mongoid::Document
    field :secret, :type => Moped::BSON::Binary

    # Create an OpenID::Association object from this object.
    # @return [OpenID::Association] Child object created from this document.
    def from_record
      OpenID::Association.new(handle, secret.to_s, Time.at(issued), lifetime, assoc_type)
    end
  end
end
