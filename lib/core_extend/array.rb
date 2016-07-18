class Array

	def nest_concat! other

		each_with_index { |arr, i| self[i].concat other[ i ] }

	end

	def nest_concat other

		d = map( &:dup )
		each_with_index { |arr, i| d[i].concat other[ i ] }

		d

	end

end
