module TidBits
module Facts
module Conditions

class Condition

include Options::Configurable, Status, InstanceCount

attr_reader :expect, :found

def initialize( **opts )

	super

	reset

end



def reset

	super

	@desire      = options.stateMachine.desire
	@actual      = options.stateMachine.actual
	@address     = options.address
	@factAddress = options.address[0...-1]
	@name        = options.address.last

	@expect = options.stateMachine.desire.dig( @address )

end



def analyze found

	setActual found

	passAnalyze
	@status

end



def setActual found

	@actual.dig!( @factAddress )[ @name ] = found

end



def check

	conclusion = @desire.dig( @address ) == @actual.dig( @address )

	conclusion and passCheck

end



def fix


end

end

end # module Conditions



end # module Facts
end # module TidBits
