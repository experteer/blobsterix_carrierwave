# -*- encoding: utf-8 -*-
require File.expand_path('../lib/blobsterix_carrierwave/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Daniel Sudmann"]
  gem.email         = ["suddani@googlemail.com"]
  gem.description   = "This gem is used to create a carrierwave binding to a blobsterix server"
  gem.summary       = "This gem is used to create a carrierwave binding to a blobsterix server"
  gem.homepage      = "http://experteer.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "blobsterix_carrierwave"
  gem.require_paths = ["lib"]
  gem.version       = BlobsterixCarrierwave::VERSION

  gem.add_dependency "carrierwave", "~> 0.9.0"
  gem.add_dependency "fog"        , "~> 1.19.0"
end
