require          'set'
require_relative 'susu/autoload'

module Susu

extend Autoload


REFINES =
{
	array:   'using Susu::Refine::Array'   ,
	hash:    'using Susu::Refine::Hash'    ,
	module:  'using Susu::Refine::Module'  ,
	numeric: 'using Susu::Refine::Numeric' ,
	fs:      'using Susu::Fs::Refine'      ,
	options: 'using Susu::Options::Refine' ,
}



def self.refine context, which = :all

	which.kind_of?( Array ) or which = [ which ]

	which.include?( :all ) and return context.eval( REFINES.values.join( "\n" ) )

	strings = REFINES.select do |key, value|

		which.include?( key )

	end.values.join( "\n" )

	context.eval strings

end



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

