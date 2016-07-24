module TidBits
module Facts
module Conditions

class Condition

include Options::Configurable, Status, InstanceCount

attr_reader :expect, :found

def initialize( **opts )

	super

	reset

	@sm          = options.stateMachine
	@desire      = @sm.desire
	@actual      = @sm.actual
	@address     = options.address
	@factAddress = options.address[0...-1]
	@name        = options.address.last

	@expect = @sm.desire( @address )

end



def analyze found

	setActual found

	analyzePassed
	@status

end



def setActual found

	@sm.actual.set( @address, found )

end



def check

	analyzed? or analyze

	@sm.desire( @address ) == @sm.actual( @address ) ? checkPassed : checkFailed

	@status

end



def fix &block

	block_given? or raise ArgumentError.new "Condition#fix requires a block"

	checked?       or  check
	checkPassed?  and  return @status

	yield
	reset
	check

	checkPassed? ? fixPassed : fixFailed

	@status

end

end

end # module Conditions



end # module Facts
end # module TidBits
