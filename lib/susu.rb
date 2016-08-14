# Susu is a library of snippets.
# Sometimes users my not want to check out all snippets (git submodules), so here
# load everything that does exist, but don't barf if some files don't.
#
module Susu

@@disabledModules = []

[
	  { name: 'CoreExtend', file: 'core_extend/lib/core_extend'  } \
	, { name: 'Fs'        , file: 'fs/lib/fs'                    } \
	, { name: 'Options'   , file: 'options/lib/options'          } \
	, { name: 'Sys'      , file: 'susu/lib/susu'                } \
	, { name: 'Facts'     , file: 'facts/lib/facts'              } \
	, { name: 'Git'       , file: 'git/lib/git'                  } \

].each do |lib|

	begin

		require_relative lib[ :file ]

	rescue LoadError

		@@disabledModules.push lib

	end

end

end # module Susu
