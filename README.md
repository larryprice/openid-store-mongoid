#openid-store-mongoid

Author: Larry Price ([larryprice.github.com](http://larryprice.github.com))  
Contact: larry.price.dev@gmail.com  
Repository Location: https://github.com/larryprice/openid-store-mongoid

##Description

OpenID Store using Mongoid. Concept originally from [Alex Young's blog](http://alexyoung.org/2010/09/28/openid-japan/).

##Usage

You should use `require 'openid-store-mongoid'` to use this gem.

To create an OpenID consumer:

``` ruby
OpenID::Consumer.new(session, OpenID::Store::MongoidStore.new)
```

To use with OmniAuth:

``` ruby
use OmniAuth::Builder do
  provider :open_id, :store => OpenID::Store::MongoidStore.new
end
```

You can cleanup any expired Nonce and Association documents from your database:

``` ruby
OpenID::Store::MongoidStore.cleanup
```

##Contributing to openid-store-mongoid
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. No pull requests will be accepted unless new features have been tested and all previous code is still tested.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

##Copyright

Copyright (c) 2013 Larry Price. See LICENSE.txt for further details.
