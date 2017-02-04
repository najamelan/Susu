module Susu
module Facts

	extend Autoload

	@modules =
	{
		Condition:      "#{ __dir__ }/facts/condition"      ,
		Fact:           "#{ __dir__ }/facts/fact"           ,
		InstanceCount:  "#{ __dir__ }/facts/instance_count" ,
		State:          "#{ __dir__ }/facts/state"          ,
		StateMachine:   "#{ __dir__ }/facts/state_machine"
	}

	def self.config; Susu.config end

end # module Facts
end # module Susu

AwesomePrint.defaults = {
# 	indent:          3,      # Indent using 4 spaces.
 	raw:             true,   # Do not recursively format object instance variables.
# 	sort_keys:       true,  # Do not sort hash keys.
# 	new_hash_syntax: false,  # Use the JSON like syntax { foo: 'bar' }, when the key is a symbol
# 	limit:           false,  # Limit large output for arrays and hashes. Set to a boolean or integer.
}


# Susu::Facts::Config.new
