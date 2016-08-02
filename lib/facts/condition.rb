module TidBits
module Facts
module Conditions

class Condition

include Options::Configurable, Status, InstanceCount

attr_reader :expect, :found, :status, :fact

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

	reset

end



def analyze found

	analyzePassed?  and  return @status

	@sm.actual.set( @address, found )

	analyzePassed

end



def check

	checkPassed? and return @status
	analyzed?     or analyze

	if @sm.desire( @address ) == @sm.actual( @address )

		return checkPassed

	else

		@fact.debug "Check failed for #{@address.ai}, expect: #{@expect.ai}, found: #{@sm.actual( @address ).ai}"
		return checkFailed

	end

end



def fix &block

	block_given? or raise ArgumentError.new "Condition#fix requires a block"

	checked?       or  check
	checkPassed?  and  fixPassed
	fixPassed?    and  return @status

	yield
	reset
	check

	checkPassed? ? fixPassed : fixFailed

end



# Let's a condition depend on another condition, possibly from another fact all
# together. This method will make sure the operation on the corresponding condition
# is run at this moment if it hasn't already run.
#
# @param  address    The address in the statemachine to the property you want to depend on.
# @param  value      The value the property needs to hold for the dependency to be met, optional.
# @param  operation  The operation of the dependency that needs to pass, default :fix.
#                    Can be :analyze, :check or :fix.
#
# @return true on success, false on failure.
#
def dependOn( address, value = nil, operation = :fix )

	desire = @sm.desire    ( address )
	cond   = @sm.conditions( address )


	cond  or

		raise "Failed to find dependency for #{address}. Caller: #{self}"


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
		if @fact.operation == :fix

			cond.fix
			result = cond.fixPassed?
			result and cond.fact.fixedAny = true

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
	value.nil? || desire == value  or

		raise "Failed to satisfy dependency for #{address}, which should be #{value}, but desired state already has #{desire}. Caller #{self}"


	result

end


end # class Condition

end # module Conditions



end # module Facts
end # module TidBits
