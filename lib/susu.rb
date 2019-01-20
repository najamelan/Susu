require          'set'
require          'logger'
require          'awesome_print'

require_relative 'susu/autoload'


module Susu
extend Autoload


@modules =
{
	DataStruct: "#{ __dir__ }/susu/datastruct" ,
	     Facts: "#{ __dir__ }/susu/facts"      ,
	        Fs: "#{ __dir__ }/susu/fs"         ,
	       Git: "#{ __dir__ }/susu/git"        ,
	   Options: "#{ __dir__ }/susu/options"    ,
	    Refine: "#{ __dir__ }/susu/refine"     ,
	       Sys: "#{ __dir__ }/susu/sys"        ,
}


@refines =
{
	    Array: [ :Refine , :Array     ],
	     Date: [ :Refine , :Date      ],
	     Hash: [ :Refine , :Hash      ],
	  Integer: [ :Refine , :Integer   ],
	   Module: [ :Refine , :Module    ],
	  Numeric: [ :Refine , :Numeric   ],
	   String: [ :Refine , :String    ],
	TarReader: [ :Refine , :TarReader ],
	     Time: [ :Refine , :Time      ],

	       Fs: [ :Fs     , :Refine    ],
	  Options: [ :Options, :Refine    ],
}



# Dynamically creates a module with the wanted refines.
# Note that some of the refines shipped by Susu alter the behavior of standard ruby methods. See the documentation for Susu::Refine for details.
# Susu caches the created modules for re-use, so you shouldn't tamper with them so you don't affect the modules other code get
# from calling this method.
#
# @param which [multiple] which can be either a something that can be converted to a symbol and that corresponds to any of the
#                         refines shipped by Susu: :Array, :Date, :Hash, :Module, :Numeric, :String, :Time, :Fs or :Options. See the
#                         documentation of Susu::Refine for more information.
#                         It can also be anything that will return a module from Object.const_get. This module will be included in the
#                         module that will be returned from this method and can have refines defined in it.
#                         You can also pass in several of the above as different parameters.
#                         It can also be an array of any combination of the above, and it is optional if you want all the refines shipped
#                         with Susu.
#
# @return [module] A module that you can pass to `using`, which will hold all the refines requested.
#
# @example
#
#   # Get all Susu refines:
#   #
#   using Susu.refines
#
#   # Get a specific set of refines:
#   #
#   using Susu.refines   :Array, :Hash      # or:
#   using Susu.refines [ :Array, :Hash ]
#
#   # To get a single refine, it is recommended to use the existing module directly, which avoids creating a new one:
#   #
#   using Susu::Refine::Hash
#
def self.refines( *which )

	which.empty? and which = @refines.keys

	# If the user send us an array already, unwrap
	#
	which.length  == 1            &&
	Array        === which.first and  which = which.first

	moduleName = 'Refines_' + which.hash.abs.to_s


	# If we have already created the module with the exact refines asked,
	# return that instead of making a new one.
	#
	begin

		return Susu.const_get moduleName

	rescue NameError

		rm = Susu.const_set( moduleName, Module.new )

	end


	for mod in which

		if !mod.kind_of?( Module )

			@refines.has_key?( mod.to_sym )  ?

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

