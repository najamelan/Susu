require 'logger'
require 'awesome_print'
require 'rugged'
require 'git'

using Susu::Refine::Module

module Susu
module Git

	extend Autoload

	@modules =
	{
		Branch:  "#{ __dir__ }/git/branch" ,
		Remote:  "#{ __dir__ }/git/remote" ,
		Repo:    "#{ __dir__ }/git/repo"
	}

	def self.config; Susu.config end


	module Facts

		extend Autoload

		@modules =
		{
			Branch:  "#{ __dir__ }/git/facts/branch" ,
			Remote:  "#{ __dir__ }/git/facts/remote" ,
			Repo:    "#{ __dir__ }/git/facts/repo"
		}

		def self.config; Susu.config end

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
