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



def analyze found

	analyzed?  and  return analyzePassed?

	@sm.actual.set( @address, found )

	analyzePassed

end



def check

	checked?  and  return checkPassed?
	analyze    or  return false

	result = @sm.desire( @address ) == @sm.actual( @address )

	result or @fact.debug "Check failed for #{@address.ai}, expect: #{@expect.ai}, found: #{@sm.actual( @address ).ai}"

	result  ?  checkPassed  :  checkFailed

end



def fix &block

	block_given? or raise ArgumentError.new "#{self.class.name}#fix requires a block"

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



# Let's a condition depend on another condition, possibly from another fact all
# together. This method will make sure the operation on the corresponding condition
# is run at this moment if it hasn't already run.
#
# @param  address    [Array] The address in the statemachine to the property you want to depend on.
# @param  value      The value the property needs to hold for the dependency to be met, optional.
# @param  operation  [Symbol] The operation of the dependency that needs to pass, default :fix.
#                             Can be :analyze, :check or :fix.
# @param  opts       [Hash]   Options for the condition in case it needs to be created.
#
# @return true on success, false on failure.
#
def dependOn( address, value = nil, operation = :fix, **opts )
# def dependOn( condition, value = nil, fact: @fact, **opts )

	desire = @sm.desire    ( address )
	cond   = @sm.conditions( address )


	if !value.nil? && !cond

		# Add the desired value to the options hash
		#
		opts[ address.last ] = value
		opts[ :address     ] = address
		fClass = Object.const_get( address.first )
		cClass = fClass.const_get( fClass.options.conditions ).const_get( address.last.to_s.capitalize! )
		cond  = @sm.conditions.set( address, cClass.new( opts ) )
		@sm.desire.set( address, value )

	end


	case operation

	when :analyze

		cond.analyze
		result = cond.analyzePassed?

	when :check

		cond.check
		result = cond.checkPassed?

	when :fix

		# Conditions can depend on eachother, however if the client didn't tell us to
		# fix, we shouldn't make changes to the system, so check @fact.operation.
		#
		if @fact.fixing?

			cond.fix

		# As a second best, if check passes, there was no need to fix, so we shall consider
		# this a success.
		#
		else

			cond.check
			result = cond.checkPassed?

		end

	end


	# If value is nil, the client doesn't care what the value is, but depends on the fact that
	# this condition exists (eg. to create a file, it needs to be known whether we should create a
	# file or a directory, but both are fine).
	#
	value.nil? || desire.nil? || desire == value  or

		raise "Failed to satisfy dependency for #{address.ai}, which should be #{value.ai}, but desired state already has #{desire.ai}. Caller #{self}"


	result

end


def systemChanged?; @systemChanged end

protected

def systemChanged; @systemChanged = true end


end # class Condition

end # module Conditions



end # module Facts
end # module TidBits
