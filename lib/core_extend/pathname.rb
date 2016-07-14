require 'pathname'


class Pathname

	def path

		self

	end

	def rpath( from = caller_locations( 1 ).first.absolute_path )

		Pathname File.join( File.dirname( from ), self.to_path )

	end

end # class Pathname
