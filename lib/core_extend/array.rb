class Array

	def nest_concat! other

		each_with_index { |arr, i| self[i].concat other[ i ] }

	end

	def nest_concat other

		d = map( &:dup )
		each_with_index { |arr, i| d[i].concat other[ i ] }

		d

	end


	# Coerce an object to be an array. Any object that is not an array will become
	# a single element array with object at index 0.
	#
	# coercing nil returns an empty array.
	#
	def self.eat( object )

	  object.nil?              and return []
	  object.kind_of?( Array ) and return object

	  [object]

	end

end

