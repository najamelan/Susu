require          'set'
require_relative 'susu/autoload'

module Susu

extend Autoload


ALL_REFINES = <<-REFINES

	using Susu::Refine::Array
	using Susu::Refine::Hash
	using Susu::Refine::Module
	using Susu::Refine::Numeric
	using Susu::Fs::Refine
	using Susu::Options::Refine

REFINES


@modules =
{
	Refine:  "#{ __dir__ }/susu/refine"  ,
	Fs:      "#{ __dir__ }/susu/fs"      ,
	Options: "#{ __dir__ }/susu/options" ,
	Facts:   "#{ __dir__ }/susu/facts"   ,
	Git:     "#{ __dir__ }/susu/git"
}



def self.configure( profile: :default, runtime: [] )

	@profile = profile

	@config  =

		Options::ConfigProfile.new(

			profile: profile                 ,
			default: [ 'susu/defaults.yml' ] ,
			runtime: runtime

		)

end


def self.config; @config end

configure

end # module Susu

