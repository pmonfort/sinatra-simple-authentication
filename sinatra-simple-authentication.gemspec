# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|

  s.name          = "sinatra-simple-authentication"
  s.version       = "0.0.1"
  s.authors       = ["Pablo Monfort"]
  s.email         = ["pmonfort@gmail.com"]
  s.description   = %q{Simple authentication plugin for sinatra.}
  s.summary       = %q{Simple authentication plugin for sinatra.}
  s.homepage      = ""
  s.require_paths = ["lib"]
  s.platform      = Gem::Platform::RUBY

  s.add_dependency "haml"
  s.add_dependency "sinatra"
  #TODO remove orms dependencies
  s.add_dependency "dm-core"
  s.add_dependency "dm-validations"
  s.add_dependency "dm-migrations"
  s.add_dependency "activerecord", "~> 3.2.3"
  s.add_dependency "dm-sqlite-adapter"
  s.add_dependency "sqlite3"
  s.add_development_dependency "ruby-debug19"
  s.add_dependency "nokogiri"
  s.add_dependency "rack-test"

  #s.rubyforge_project = "lorem"

  s.files = [
      "lib/sinatra/models/abstract_user.rb",
      "lib/sinatra/models/datamapper/user.rb",
      "lib/sinatra/models/datamapper/adapter.rb",
      "lib/sinatra/models/active_record/user.rb",
      "lib/sinatra/views/login.haml",
      "lib/sinatra/views/signup.haml",
      "lib/sinatra/views/_form.haml",
      "lib/sinatra/simple-authentication.rb"
    ]

  s.test_files    = Dir.glob('test/simple_authentication_test.rb')
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
end
