# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'varnish_rest_api_client/version'

Gem::Specification.new do |spec|
  spec.name          = "varnish_rest_api_client"
  spec.version       = VarnishRestApiClient::VERSION
  spec.authors       = ["Jonathan Colby"]
  spec.email         = ["jcolby@team.mobile.de"]

  spec.summary       = %q{A command line client for the varnish rest api.}
  spec.description   = %q{A command line client for the varnish rest api.}
  spec.homepage      = "http://homepage.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files	<< ["bin/varnishapiclient.rb"]
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end
  
  spec.add_dependency "thor"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
