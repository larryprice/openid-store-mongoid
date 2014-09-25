# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: openid-store-mongoid 0.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "openid-store-mongoid"
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Larry Price"]
  s.date = "2014-09-25"
  s.description = "Use a Mongoid database to store OpenID consumer data."
  s.email = "larry.price.dev@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/openid-store-mongoid.rb",
    "lib/openid/store/models/association.rb",
    "lib/openid/store/models/nonce.rb",
    "lib/openid/store/mongoid_store.rb",
    "openid-store-mongoid.gemspec",
    "spec/openid-store-mongoid_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/larryprice/openid-store-mongoid"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "OpenID Store using Mongoid."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, ["~> 3.1"])
      s.add_runtime_dependency(%q<ruby-openid>, ["~> 2.2"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<redcarpet>, ["~> 2.2"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
    else
      s.add_dependency(%q<mongoid>, ["~> 3.1"])
      s.add_dependency(%q<ruby-openid>, ["~> 2.2"])
      s.add_dependency(%q<rspec>, ["~> 2.8"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<redcarpet>, ["~> 2.2"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<mongoid>, ["~> 3.1"])
    s.add_dependency(%q<ruby-openid>, ["~> 2.2"])
    s.add_dependency(%q<rspec>, ["~> 2.8"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<redcarpet>, ["~> 2.2"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
  end
end

