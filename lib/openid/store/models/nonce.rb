require 'mongoid'
require 'openid'

module OpenID::Store
  # Wrapper class for an OpenID::Nonce object.
  class Nonce
    include Mongoid::Document
  end
end
