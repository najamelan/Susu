module TidBits
module Facts

class Pash < Options::Settings

protected

# Make sure keys are always symbols
#
def convert_key( key ) key end

end # class Pash


class StateMachine

attr_reader :actual, :desire, :conditions

def initialize( **opts )

	@actual     = Pash.new
	@desire     = Pash.new
	@conditions = Pash.new

end

end # class  StateMachine



end # module Facts
end # module TidBits
