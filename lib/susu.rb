require          'set'
require          'logger'
require          'awesome_print'

require_relative 'susu/autoload'

module Susu

extend Autoload

VERSION = '0.1.0'


@refineCounter = 0


@modules =
{
	Refine:  "#{ __dir__ }/susu/refine"  ,
	Fs:      "#{ __dir__ }/susu/fs"      ,
	Options: "#{ __dir__ }/susu/options" ,
	Facts:   "#{ __dir__ }/susu/facts"   ,
	Git:     "#{ __dir__ }/susu/git"
}

@refines =
{
	Array:   [ :Refine , :Array   ],
	Date:    [ :Refine , :Date    ],
	Hash:    [ :Refine , :Hash    ],
	Module:  [ :Refine , :Module  ],
	Numeric: [ :Refine , :Numeric ],
	String:  [ :Refine , :String  ],
	Time:    [ :Refine , :Time    ],

	Fs:      [ :Fs     , :Refine  ],
	Options: [ :Options, :Refine  ],
}



def self.refines( *args )


	args.empty? and args = @refines.keys

	# If the user send us an array already, unwrap
	#
	args.length  == 1           &&
	Array       === args.first and  args = args.first

	@refineCounter += 1
	rm = Susu.const_set( 'Refines' + @refineCounter.to_s, Module.new )

	for mod in args

		if !mod.kind_of?( Module )

			@refines.has_key?( mod )  ?

				  mod = Susu  .const_get( @refines[ mod ], false )
				: mod = Object.const_get( mod            , false  )

		end

		rm.include mod

	end

	rm

end



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

