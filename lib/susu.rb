require          'set'
require_relative 'susu/autoload'

module Susu

extend Autoload


REFINES =
{
	Array:   'using Susu::Refine::Array'   ,
	Date:    'using Susu::Refine::Date'    ,
	Hash:    'using Susu::Refine::Hash'    ,
	Module:  'using Susu::Refine::Module'  ,
	Numeric: 'using Susu::Refine::Numeric' ,
	String:  'using Susu::Refine::String'  ,
	Time:    'using Susu::Refine::Time'    ,

	Fs:      'using Susu::Fs::Refine'      ,
	Options: 'using Susu::Options::Refine' ,
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



# TODO: What if several libs or apps configure Susu?
#
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

