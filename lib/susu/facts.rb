require 'logger'
require 'awesome_print'
require 'set'

using Susu::Refine::Module

module Susu
module Facts

	autoload_relative  :Condition     , 'facts/condition'
	autoload_relative  :Config        , 'facts/config'
	autoload_relative  :Fact          , 'facts/fact'
	autoload_relative  :InstanceCount , 'facts/instance_count'
	autoload_relative  :Path          , 'facts/path'
	autoload_relative  :State         , 'facts/state'
	autoload_relative  :StateMachine  , 'facts/state_machine'

end # module Facts
end # module Susu

AwesomePrint.defaults = {
# 	indent:          3,      # Indent using 4 spaces.
 	raw:             true,   # Do not recursively format object instance variables.
# 	sort_keys:       true,  # Do not sort hash keys.
# 	new_hash_syntax: false,  # Use the JSON like syntax { foo: 'bar' }, when the key is a symbol
# 	limit:           false,  # Limit large output for arrays and hashes. Set to a boolean or integer.
}


Susu::Facts::Config.new
