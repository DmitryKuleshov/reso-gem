$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "reso/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "reso"
  spec.version     = Reso::VERSION
  spec.authors       = ["Dzmitry Kuliashou"]
  spec.email         = ["bubom@yandex.ru"]
  spec.homepage      = "http://perchwell.com"
  spec.summary       = %q{RESO Gem for Perchwell.}
  spec.description   = %q{RESO for Perchwell.}
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails"

  spec.add_development_dependency "sqlite3"
end
