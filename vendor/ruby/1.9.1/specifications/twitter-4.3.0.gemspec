# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "twitter"
  s.version = "4.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker", "Wynn Netherland", "Erik Michaels-Ober", "Steve Richert"]
  s.date = "2012-11-20"
  s.description = "A Ruby interface to the Twitter API."
  s.email = ["nunemaker@gmail.com", "wynn.netherland@gmail.com", "sferik@gmail.com", "steve.richert@gmail.com"]
  s.homepage = "http://sferik.github.com/twitter/"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23.2"
  s.summary = "A Ruby interface to the Twitter API."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>, ["~> 0.8"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.3"])
      s.add_runtime_dependency(%q<simple_oauth>, ["~> 0.1.6"])
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<faraday>, ["~> 0.8"])
      s.add_dependency(%q<multi_json>, ["~> 1.3"])
      s.add_dependency(%q<simple_oauth>, ["~> 0.1.6"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<faraday>, ["~> 0.8"])
    s.add_dependency(%q<multi_json>, ["~> 1.3"])
    s.add_dependency(%q<simple_oauth>, ["~> 0.1.6"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
