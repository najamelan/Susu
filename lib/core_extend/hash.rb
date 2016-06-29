# Contains new methods to extend the native Hash class with extra functionality.
#
# @author Naja Melan <najamelan@autistici.org>
#
class Hash

# Will merge a hash, merging all nested hashes instead of replacing the original.
# In place version of recursive_merge
#
# @param       (see #recursive_merge)
# @return      (see #recursive_merge)
#
def recursive_merge!( override )

	self.merge! override do |key, a, b|

		a.is_a?( Hash ) && b.is_a?( Hash ) ? a.recursive_merge!( b ) : b

	end

	self

end

# Will merge a hash, merging all nested hashes instead of replacing the original.
#
# @param       override [Hash] The hash from which to take overriding values.
# @return               [Hash] a duplicate of self with values overriden from override.
#
def recursive_merge( override )

	target = dup
	target.recursive_merge!( override )

end


end
