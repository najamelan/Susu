# TidBits is a library of snippets.
# Sometimes users my not want to check out all snippets (git submodules), so here
# load everything that does exist, but don't barf if some files don't.
#
module TidBits

[
	  { name: 'CoreExtend', file: 'core_extend/lib/core_extend'  } \
	, { name: 'Git'       , file: 'git/lib/git'                  } \
	, { name: 'Options'   , file: 'options/lib/options'          } \
	, { name: 'Rush'      , file: 'rush/lib/rush'                } \
	, { name: 'Susu'      , file: 'susu/lib/susu'                } \

].each do |lib|

	begin

		require_relative lib[ :file ]

	rescue LoadError

		puts "Submodule #{ lib[ :name ] } not present."

	end

end

end # module TidBits
