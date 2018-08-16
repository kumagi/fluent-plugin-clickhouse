# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-clickhouse"
  spec.version       = "0.0.1"
  spec.authors       = ["Hiroki KUMAZAKI"]
  spec.email         = ["hiroki.kumazaki@gmail.com"]

  spec.summary       = %q{Fluentd output plugin for inserting into ClickHouse.}
  spec.description   = %q{Fluentd output inserted into ClickHouse as fast column-oriented OLAP DBMS.}
  spec.homepage      = "https://github.com/kumagi/fluent-plugin-clickhouse"
  spec.license       = "Apache2.0"

  spec.rubyforge_project = "fluent-plugin-clickhouse"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
  spec.add_runtime_dependency "fluentd"
  spec.add_runtime_dependency "clickhouse"
end
