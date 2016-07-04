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


end # class Hash
