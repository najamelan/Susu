require 'pathname'


class Pathname


	# Runs Pathname.glob
	#
	# @param  pattern  The pattern will be created by doing self + pattern if
	#                  self.directory? otherwise, it will be self.dirname + pattern
	# @param  flags    The flags as in File::Constants, see Dir.glob
	# @param  block    The block will receive the pathname of each found path as parameter.
	#
	# @return nil
	#
	def glob( pattern, flags = 0, &block )

		p = self
		p.directory? or p = p.dirname

		Pathname.glob p + pattern, flags, &block

	end


	def path

		self

	end

	def relpath( from = caller_locations( 1 ).first.absolute_path )

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
