module TidBits
module Facts

class Pash < Options::Settings


def set address, value

	location = dig!( *address[0...-1] )
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
	@desire     = Pash.new
	@conditions = Pash.new

end



#-------------------------------------------------------------------------------
# Will dig into the desired state to retrieve the value located at given address.
#
# @param  address [Array|segment1, segment2, ...] The path to the requested value as
#                 an array of path segments. Can also be several parameters not in array.
#
# @return The item at requested location or nil if it doesn't exist.
#
def desire( *address )

	# This allows to call this function with an array without having to splat on caller side.
	#
	address.length == 1  &&  address.first.kind_of?( Array ) and address = address.first

	@desire.dig( *address )

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

	# This allows to call this function with an array without having to splat on caller side.
	#
	address.length == 1  &&  address.first.kind_of?( Array ) and address = address.first

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

	# This allows to call this function with an array without having to splat on caller side.
	#
	address.length == 1  &&  address.first.kind_of?( Array ) and address = address.first

	@conditions.dig( *address )

end



#-------------------------------------------------------------------------------
# Will dig! into the desired state to retrieve the value located at given address.
# The location keys that don't exist yet will be created.
#
# @param  address [Array|segment1, segment2, ...] The path to the requested value as
#                 an array of path segments. Can also be several parameters not in array.
#
# @return The item at requested location or nil if it doesn't exist.
#
def desire!( *address )

	# This allows to call this function with an array without having to splat on caller side.
	#
	address.length == 1  &&  address.first.kind_of?( Array ) and address = address.first

	@desire.dig!( *address )

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

	# This allows to call this function with an array without having to splat on caller side.
	#
	address.length == 1  &&  address.first.kind_of?( Array ) and address = address.first

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

	# This allows to call this function with an array without having to splat on caller side.
	#
	address.length == 1  &&  address.first.kind_of?( Array ) and address = address.first

	@conditions.dig!( *address )

end



end # class  StateMachine



end # module Facts
end # module TidBits
