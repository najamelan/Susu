using Susu.refines
module Susu
module Facts


class Condition

include Options::Configurable, State, InstanceCount

attr_accessor :fact
attr_reader   :expect, :found, :state

protected :reset



def self.configure( config )

	config.setup( self, :Facts, :Condition )

end



def initialize **opts

	super

	@fact     = fact
	@sm       = options.stateMachine
	@address  = options.address
	@factAddr = options.address[ 0...-1 ]
	@name     = options.address.last

	@actual   = @sm.actual

	@expect   = options[ @name ]

	@systemChanged = false

	reset

end



def analyze &block

	block_given? or raise ArgumentError.new "Condition#Analyze requires a block."

	analyzed?  and  return analyzePassed?

	found = yield
	analyzeFailed? and return false

	@sm.actual.set( @address, found )

	analyzePassed

end



# TODO: Let the user set a value that responds to call and use that to check rather than
# below options. The block is not really an alternative, since users don't usually call
# check manually, its been called from a fact. However the block is good for subclasses that want to override the check.
#
def check &block

	checked?  and  return checkPassed?
	analyze    or  return false


	result = block_given? ?

		  yield( @expect, @sm.actual( @address ) )
		: @expect == @sm.actual( @address )


	result  ?  checkPassed  :  checkFailed

end



def fix &block

	block_given? or raise ArgumentError.new "Condition#fix requires a block."

	fixed?          and  return fixPassed?
	check           and  return true

	# If we we can't analyze, we can't check, let alone fix
	#
	analyzePassed?   or  return false

	yield
	reset
	check

	checkPassed?  ?  fixPassed  :  fixFailed

end



# Let's a condition depend on another condition from the same fact. If it doesn't exist, it will be added to the fact.
# This method will test check on the corresponding condition and if it hasn't already run and we are fixing it
# will attempt to fix the condition. If this method returns false, you should abort your operation.
#
# @param  name   [Symbol]  Which condition to depend on (lower case)
# @param  value  [Object]  The value the property needs to hold for the dependency to
#                          be met, optional.
# @param  opts   [Hash]    Possible overrides of options to be used if the condition needs to be created.
#
# @return true on success, false on failure.
#
def dependOn( name, value = nil, **opts )

	value.nil? and value = options[ name ]

	cond      = @fact.condition( name, value, opts )
	cond.fact = fact


	case @fact.operation

		when :fixing; cond.fix
		else          cond.check

	end


end



def dependOnFact( factClass, **opts )

	fact = @sm.facts

	# Add the desired value to the options hash
	#
	fClass = Object.const_get( address.first )
	cClass = fClass.const_get( fClass.options.conditions ).const_get( address.last.to_s.capitalize! )
	cond   = @sm.conditions.set( address, cClass.new( opts ) )

	@sm.desire.set( address, value )

end



def systemChanged?; @systemChanged end

protected

def systemChanged; @systemChanged = true end


end # class  Condition
end # module Facts
end # module Susu
