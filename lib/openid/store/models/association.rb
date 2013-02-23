require 'mongoid'
require 'openid/association'

module OpenID::Store
  class Association
    include Mongoid::Document
    field :secret, :type => Moped::BSON::Binary

    def from_record
      OpenID::Association.new(handle, secret.to_s, Time.at(issued), lifetime, assoc_type)
    end
  end
end
