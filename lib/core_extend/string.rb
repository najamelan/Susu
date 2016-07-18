require 'pathname'


class String


	# Convert to Pathname. Note that #to_path cannot be used because Pathname already uses it and it should return a string.
	#
	def path

		Pathname self

	end


	# Provide an easy way of creating relative paths from any source file.
	#
	# @param  from  [String/Pathname] The directory or a file therein to which the path is relative
	#
	# @return returns a Pathname object relative to from.
	#
	def relpath( from = caller_locations( 1 ).first.absolute_path )

		Pathname File.join( File.dirname( from ), self )

	end


	def to_path

		self

	end


end # class String
