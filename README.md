#openid-store-mongoid

OpenID Store Using Mongoid. Concept originally discovered on [Alex Young's blog](http://alexyoung.org/2010/09/28/openid-japan/).

##Usage

When creating an OpenID consumer:

``` ruby
OpenID::Consumer.new(session, OpenID::Store::MongoidStore.new)
```

With OmniAuth:

``` ruby
use OmniAuth::Builder do
  provider :open_id, :store => OpenID::Store::MongoidStore.new
end
```

##Contributing to openid-store-mongoid
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

##Copyright

Copyright (c) 2013 Larry Price. See LICENSE.txt for further details.

