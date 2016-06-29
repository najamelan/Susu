# Contains new methods to extend the native Hash class with extra functionality.
#
# @author Naja Melan <najamelan@autistici.org>
#
class Hash

# Will merge a hash, merging all nested hashes instead of replacing the original.
# In place version of recursiveMerge
#
# @param       (see #recursiveMerge)
# @return      (see #recursiveMerge)
#
def recursiveMerge!( override )

	self.merge! override do |key, a, b|

		a.is_a?( Hash ) && b.is_a?( Hash ) ? a.recursiveMerge!( b ) : b

	end

	self

end

# Will merge a hash, merging all nested hashes instead of replacing the original.
#
# @param       override [Hash] The hash from which to take overriding values.
# @return               [Hash] a duplicate of self with values overriden from override.
#
def recursiveMerge( override )

	target = dup
	target.recursiveMerge!( override )

end


end # class Hash
