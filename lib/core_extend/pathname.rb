require 'pathname'


class Pathname

	def path

		self

	end

	def rpath( from = caller_locations( 1 ).first.absolute_path )

		Pathname File.join( File.dirname( from ), self.to_path )

	end


	# Secure recursive delete of path.
	# @see FileUtils.remove_entry_secure
	#
	def rm_secure( force = false )

	  require 'fileutils'

	  FileUtils.remove_entry_secure( @path, force )

	  nil
	end



end # class Pathname
