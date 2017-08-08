using Susu.refines

module Susu
module Facts

class Pash < Options::Settings


def set address, value

	location                 = dig!( *address[0...-1] )
	location[ address.last ] = value

end



protected

# Make sure keys are always symbols
#
def convert_key( key ) key end


end # class Pash


class StateMachine



def initialize( **opts )

	@actual     = Pash.new
	@facts      = Pash.new
	@conditions = Pash.new

end



#-------------------------------------------------------------------------------
# Will dig into the actual state to retrieve the value located at given address.
#
# @param  address [Array|segment1, segment2, ...] The path to the requested value as
#                 an array of path segments. Can also be several parameters not in array.
#
# @return The item at requested location or nil if it doesn't exist.
#
def actual( *address )

	address = Array.spit address

	@actual.dig( *address )

end



#-------------------------------------------------------------------------------
# Will dig into the conditions to retrieve the condition located at given address.
#
# @param  address [Array|segment1, segment2, ...] The path to the requested condition as
#                 an array of path segments. Can also be several parameters not in array.
#
# @return The condition at requested location or nil if it doesn't exist.
#
def conditions( *address )

	address = Array.spit address

	@conditions.dig( *address )

end



#-------------------------------------------------------------------------------
# Will dig into the facts to retrieve the fact located at given address.
#
# @param  address [Array|segment1, segment2, ...] The path to the requested fact as
#                 an array of path segments. Can also be several parameters not in array.
#
# @return The fact at requested location or nil if it doesn't exist.
#
def facts( *address )

	address = Array.spit address

	@facts.dig( *address )

end



#-------------------------------------------------------------------------------
# Will dig! into the actual state to retrieve the value located at given address.
# The location keys that don't exist yet will be created.
#
# @param  address [Array|segment1, segment2, ...] The path to the requested value as
#                 an array of path segments. Can also be several parameters not in array.
#
# @return The item at requested location or nil if it doesn't exist.
#
def actual!( *address )

	address = Array.spit address

	@actual.dig!( *address )

end



#-------------------------------------------------------------------------------
# Will dig! into the conditions to retrieve the condition located at given address.
# The location keys that don't exist yet will be created.
#
# @param  address [Array|segment1, segment2, ...] The path to the requested condition as
#                 an array of path segments. Can also be several parameters not in array.
#
# @return The condition at requested location or nil if it doesn't exist.
#
def conditions!( *address )

	address = Array.spit address

	@conditions.dig!( *address )

end



#-------------------------------------------------------------------------------
# Will dig! into the facts to retrieve the fact located at given address.
# The location keys that don't exist yet will be created.
#
# @param  address [Array|segment1, segment2, ...] The path to the requested fact as
#                 an array of path segments. Can also be several parameters not in array.
#
# @return The fact at requested location or nil if it doesn't exist.
#
def facts!( *address )

	address = Array.spit address

	@facts.dig!( *address )

end


end # class  StateMachine



end # module Facts
end # module Susu
