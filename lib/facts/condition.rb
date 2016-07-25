module TidBits
module Facts
module Conditions

class Condition

include Options::Configurable, Status, InstanceCount

attr_reader :expect, :found

def initialize **opts

	super

	@sm          = options.stateMachine
	@address     = options.address
	@factAddress = options.address[0...-1]
	@name        = options.address.last

	@desire      = @sm.desire
	@actual      = @sm.actual

	@fact        = @sm.facts( @factAddress )
	@expect      = @sm.desire( @address )

	reset

end



def analyze found

	analyzePassed?  and  return @status

	@sm.actual.set( @address, found )

	analyzePassed

end



def check

	analyzed? or analyze

	@sm.desire( @address ) == @sm.actual( @address ) ? checkPassed : checkFailed

end



def fix &block

	block_given? or raise ArgumentError.new "Condition#fix requires a block"

	checked?       or  check
	checkPassed?  and  return @status

	yield
	reset
	check

	checkPassed? ? fixPassed : fixFailed

end



def dependOn( address, value, operation = :check )

	desire = @sm.desire    ( address )
	cond   = @sm.conditions( address )

	! desire || ! cond and raise "Failed to find dependency for #{address}, which should be #{value}. Caller: #{self}"
	desire != value    and raise "Failed to satisfy dependency for #{address}, which should be #{value}, but desired state already has #{desire}. Caller #{self}"

	case operation

	when :analyze

		cond.analyzePassed? or  cond.analyze
		cond.analyzePassed? and return true

	when :check

		cond.checkPassed? or  cond.check
		cond.checkPassed? and return true

	when :fix

		cond.fixPassed? or  cond.fix
		cond.fixPassed? and return true

	end

	false

end


end # class Condition

end # module Conditions



end # module Facts
end # module TidBits
