
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "perchwell_reso/version"

Gem::Specification.new do |spec|
  spec.name          = "perchwell-reso"
  spec.version       = PerchwellReso::VERSION
  spec.authors       = ["Dzmitry Kuliashou"]
  spec.email         = ["bubom@yandex.ru"]

  spec.summary       = %q{RESO Gem for Perchwell.}
  spec.description   = %q{RESO for Perchwell.}
  spec.homepage      = "http://perchwell.com"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/DmitryKuleshov/reso-gem"
    spec.metadata["changelog_uri"] = "https://github.com/DmitryKuleshov/reso-gem"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #spec.add_dependency 'bcrypt', '>= 3.1.1'
  #spec.add_dependency 'argon2', '~> 2.0', '>= 2.0.2'
  #spec.add_dependency 'email_validator', '~> 2.0'
  #spec.add_dependency 'railties', '>= 4.0'
  #spec.add_dependency 'activemodel', '>= 4.0'
  #spec.add_dependency 'activerecord', '>= 4.0'
  #spec.add_dependency 'actionmailer', '>= 5.0'
  spec.add_dependency "rails"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3"
end