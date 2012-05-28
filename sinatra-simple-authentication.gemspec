# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|

  s.name          = "sinatra-simple-authentication"
  s.version       = "1.0.0"
  s.authors       = ["Pablo Monfort"]
  s.email         = ["pmonfort@gmail.com"]
  s.description   = %q{Basic authentication gem with support for Datamapper and ActiveRecord.}
  s.summary       = %q{Simple authentication plugin for sinatra.}
  s.homepage      = "https://github.com/pmonfort/sinatra-simple-authentication"
  s.require_paths = ["lib"]
  s.platform      = Gem::Platform::RUBY

  s.add_dependency "haml"
  s.add_dependency "sinatra"
  s.add_development_dependency "dm-core"
  s.add_development_dependency "dm-validations"
  s.add_development_dependency "dm-migrations"
  s.add_development_dependency "dm-sqlite-adapter"
  s.add_development_dependency "activerecord", "~> 3.2.3"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "rack-test"

  #s.rubyforge_project = "lorem"

  s.files = [
      "lib/sinatra/simple_authentication/models/datamapper/user.rb",
      "lib/sinatra/simple_authentication/models/datamapper/adapter.rb",
      "lib/sinatra/simple_authentication/models/active_record/user.rb",
      "lib/sinatra/simple_authentication/models/active_record/adapter.rb",
      "lib/sinatra/simple_authentication/models/common/instance_methods.rb",
      "lib/sinatra/simple_authentication/views/login.haml",
      "lib/sinatra/simple_authentication/views/signup.haml",
      "lib/sinatra/simple_authentication/views/_form.haml",
      "lib/sinatra/simple_authentication/controllers/defaults.rb",
      "lib/sinatra/simple_authentication/controllers/helpers.rb",
      "lib/sinatra/simple_authentication/controllers/session.rb",
      "lib/sinatra/simple-authentication.rb"
    ]

  s.test_files    = Dir.glob('test/tc_*.rb')
end
