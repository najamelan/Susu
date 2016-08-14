require 'logger'
require 'awesome_print'
require 'set'

module Susu
module Facts

	autoload :Condition     , File.join( __dir__, 'facts/condition'       )
	autoload :Config        , File.join( __dir__, 'facts/config'          )
	autoload :Fact          , File.join( __dir__, 'facts/fact'            )
	autoload :InstanceCount , File.join( __dir__, 'facts/instance_count'  )
	autoload :Path          , File.join( __dir__, 'facts/path'            )
	autoload :State         , File.join( __dir__, 'facts/state'           )
	autoload :StateMachine  , File.join( __dir__, 'facts/state_machine'   )

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
