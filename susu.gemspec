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
	s.add_runtime_dependency 'hashie'         , "~> 3"
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
	s.add_development_dependency 'yard', '~> 0'


	# If you need to check in files that aren't .rb files, add them here
	#
	s.files = Dir[ "lib/**/*", "test/**/*", "test/git/data/fixtures/clean/.gitted/**/*", "*.md", "Thorfile" ]

	# If you need an executable, add it here
	#
	# s.executables << ''

end
