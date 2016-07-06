# Contains new methods to extend the native Hash class with extra functionality.
#
# @author Naja Melan <najamelan@autistici.org>
#
class Hash

# Searches in nested hashes for a certain path.
#
# @param  path [HashKey, ...] A comma separated list of hash keys.
# @return      [HashValue]    The value of the path requested or nil if it doesn't exist.
#
# @example Usage
#   people  = { anna: { children: { kenny: { hobbies: dancing }, bibi: { age: 12 } } } }
#   age     = people.dig( :anna, :children, :bibi, :age     ) => 12
#   hobbies = people.dig( :anna, :children, :bibi, :hobbies ) => nil
#
# from: https://stackoverflow.com/a/1820492/1115652
#
def dig( *path )

  path.reduce( self ) do | location, key |

    location.respond_to?( :keys ) ? location[ key ] : nil

  end

end


def superset?( other )

	deep_merge( other ) == self

end


def subset?( other )

	other.deep_merge( self ) == other

end



# Returns a hash that represents the difference between two hashes.
# RIP: https://github.com/rails/rails/commit/01f0c3f308542afa8fa262638d94d10420bd2e78
#
# NOTE: when the two hashes have different values for the same key the value for the
# instance on which diff is called is maintained.
#
# @example Usage
#
#   {1 => 2}.diff(1 => 2)         # -> {}
#   {1 => 2}.diff(1 => 3)         # -> {1 => 2}
#   {}.diff(1 => 2)               # -> {1 => 2}
#   {1 => 2, 3 => 4}.diff(1 => 2) # -> {3 => 4}
#   a.diff( b ).diff( b ) == a    # -> true
#
def diff( other )

	               dup.delete_if { |k, v| other[k] == v } \
	.merge!( other.dup.delete_if { |k, v| has_key? k    } )

end





end # class Hash
