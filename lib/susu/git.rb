require 'logger'
require 'awesome_print'
require 'rugged'
require 'git'


module Susu
module Git

	autoload :Branch  , File.join( __dir__, 'git/branch' )
	autoload :Config  , File.join( __dir__, 'git/config' )
	autoload :Remote  , File.join( __dir__, 'git/remote' )
	autoload :Repo    , File.join( __dir__, 'git/repo'   )

	module Facts

		autoload :Branch , File.join( __dir__, 'git/facts/branch' )
		autoload :Remote , File.join( __dir__, 'git/facts/remote' )
		autoload :Repo   , File.join( __dir__, 'git/facts/repo'   )

	end

end # module Git
end # module Susu


AwesomePrint.defaults = {
# 	indent:          3,      # Indent using 4 spaces.
 	raw:             true,   # Do not recursively format object instance variables.
# 	sort_keys:       true,  # Do not sort hash keys.
# 	new_hash_syntax: false,  # Use the JSON like syntax { foo: 'bar' }, when the key is a symbol
# 	limit:           false,  # Limit large output for arrays and hashes. Set to a boolean or integer.
}

Susu::Git::Config.new
