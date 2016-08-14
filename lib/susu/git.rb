require 'logger'
require 'awesome_print'
require 'rugged'
require 'git'

using Susu::Refine::Module

module Susu
module Git

	autoload_relative :Branch  , 'git/branch'
	autoload_relative :Config  , 'git/config'
	autoload_relative :Remote  , 'git/remote'
	autoload_relative :Repo    , 'git/repo'

	module Facts

		autoload_relative :Branch , 'git/facts/branch'
		autoload_relative :Remote , 'git/facts/remote'
		autoload_relative :Repo   , 'git/facts/repo'

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
