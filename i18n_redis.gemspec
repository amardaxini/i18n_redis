# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "i18n_redis/version"

Gem::Specification.new do |s|
  s.name        = "i18n_redis"
  s.version     = I18nRedis::VERSION
  s.authors     = ["Amar Daxini"]
  s.email       = ["amar.daxini@livialegal.com"]
  s.homepage    = ""
  s.summary     = %q{I18n YAML to Redis Management}
  s.description = %q{I18n YAML to Redis Management.It convert exising yaml to redis.Provides various helper methods to add,update,remove,create,copy master to another locale,one locale to another locale etc.}

  s.rubyforge_project = "i18n_redis"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency(%q<redis>, ["~> 2.2.0"])
end
