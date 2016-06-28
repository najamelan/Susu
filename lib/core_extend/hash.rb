class Hash

# Will merge a hash, merging all nested hashes instead of replacing the original.
# In place version of recursive_merge
#
# @parameter override [Hash] The hash from which to take overriding values.
# @return             [Hash] self.
#
def recursive_merge!( override )

	self.merge! override do |key, a, b|

		a.is_a?( Hash ) && b.is_a?( Hash ) ? a.recursive_merge!( b ) : b

	end

	self

end

# Will merge a hash, merging all nested hashes instead of replacing the original.
#
# @parameter override [Hash] The hash from which to take overriding values.
# @return             [Hash] a duplicate of self with values overriden from override.
#
def recursive_merge( override )

	target = dup
	target.recursive_merge!( override )

end


end
