# -*- encoding: utf-8 -*-

require_relative 'lib/susu/version'

Gem::Specification.new do |s|

	s.name         = "susu"
	s.version      = Susu::VERSION
	s.date         = '2018-08-17'
	s.author       = 'Naja Melan'
	s.email        = 'najamelan@autistici.org'
	s.homepage     = 'https://github.com/najamelan/susu'
	s.summary      = "Application framework for ruby"
	s.description  = "Application framework for ruby - description"
	s.license      = 'Unlicense'


	# If you have other dependencies, add them here
	#
	# Hashie now calls YAML.safe_load which breaks on unquoted date strings. This is a problem for Options.
	# We need to figure out how to deal with this. For now it would mean that anytime a user puts
	# an unquoted date string in a yaml file, we get an exception and in any case we have to parse dates
	# ourselves and figure out how to do it safely...
	#
	s.add_runtime_dependency 'hashie'         , [ ">= 3.5.7", "< 3.6" ]
	s.add_runtime_dependency 'rugged'         , "~> 0"
	s.add_runtime_dependency 'git'            , "~> 1"
	s.add_runtime_dependency 'activesupport'  , "~> 5"
	s.add_runtime_dependency 'thor'           , "~> 0"

	s.add_runtime_dependency 'awesome_print'  , "~> 1"
	s.add_runtime_dependency 'byebug'         , "~> 10"
	s.add_runtime_dependency 'pry'            , "~> 0"
	s.add_runtime_dependency 'test-unit'      , "~> 3"

	# Development
	#
	s.add_development_dependency 'yard'     , '~> 0'
	s.add_development_dependency 'coveralls', '~> 0'


	# If you need to check in files that aren't .rb files, add them here
	#
	s.files = Dir[ "lib/**/*", "test/**/*", "test/git/data/fixtures/clean/.gitted/**/*", "*.md", "Thorfile" ]

	# If you need an executable, add it here
	#
	# s.executables << ''

end
