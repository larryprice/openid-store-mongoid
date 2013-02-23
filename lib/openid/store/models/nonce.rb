require 'mongoid'
require 'openid'

module OpenID::Store
  class Nonce
    include Mongoid::Document
  end
end
