module TidBits
module Facts
module Conditions

class Condition

include Options::Configurable, Status, InstanceCount

attr_reader :expect, :found, :status, :fact

protected :reset

def initialize **opts

	super

	@sm       = options.stateMachine
	@address  = options.address
	@factAddr = options.address[0...-1]
	@name     = options.address.last

	@desire   = @sm.desire
	@actual   = @sm.actual

	@fact     = @sm.facts( @factAddr )
	@expect   = @sm.desire( @address )

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



def check &block

	checked?  and  return checkPassed?
	analyze    or  return false

	result = block_given? ?

		  yield
		: @sm.desire( @address ) == @sm.actual( @address )


	result or @fact.debug "Check failed for #{@address.ai}, expect: #{@expect.ai}, found: #{@sm.actual( @address ).ai}"

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
# This method will test check on the corresponding condition at this and if it hasn't already run and we are fixing it
# will attempt to fix the condition. If the method returns false, you should abort your operation.
#
# @param  condition  The condition
# @param  value      The value the property needs to hold for the dependency to
#                    be met, optional.
# @param  opts       [Hash] Possible overrides of options to be used if the condition needs to be created.
#
# @return true on success, false on failure.
#
def dependOn( condition, value, **opts )

	address = @factAddr.dup << condition


	# If the condition doesn't exist, create it
	#
	if !@sm.conditions( address )

		opts              = options.deep_merge opts
		opts[ condition ] = value

		@fact.addCondition( condition, value )

	end


	cond   = @sm.conditions( address )

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
	cond  = @sm.conditions.set( address, cClass.new( opts ) )
	@sm.desire.set( address, value )
end



def systemChanged?; @systemChanged end

protected

def systemChanged; @systemChanged = true end


end # class Condition

end # module Conditions



end # module Facts
end # module TidBits
