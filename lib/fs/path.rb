require 'pathname'


module TidBits
module Fs

class Path < Pathname


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

	Dir.glob( ( p + pattern ), flags, &block ).map!( &:path )

end


def path

	self

end


def relpath( from = caller_locations( 1 ).first.absolute_path )

	self.class.new File.join( File.dirname( from ), @path )

end


# Will make a path, creating intermediate directories as needed.
#
# @param  subPath  The sub path to create relative to the path of self.
# @param  options  The options as take by FileUtils.mkpath (eg. mode, noop, verbose)
#
# @return A Path object to the new directory.
#
def mkpath( subPath = '', options = {} )

	require 'fileutils'

	make = join( subPath )

	FileUtils.mkpath( make.to_path )

	make

end


# Will create a directory
#
# @param  [Path|String] subPath  The sub path to create relative to the path of self.
# @param  [FixNum]      mode     The permissions for the new directory.
#
# @return A Path object to the new directory.
#
def mkdir( subPath = '', mode = 0777 )

	make = join( subPath )

	Dir.mkdir( make.to_path, mode )

	make

end


# Secure recursive delete of path.
# @see FileUtils.remove_entry_secure
#
def rm_secure( force = false )

  require 'fileutils'

  FileUtils.remove_entry_secure( @path, force )

end


def join( *args )

  args.unshift self

  result = args.pop
  result.kind_of?( self.class )  or  result = self.class.new( result )

  result.absolute? and return result

  args.reverse_each do |arg|

    arg.kind_of?( self.class )  or  arg = self.class.new( arg )
    result = arg + result

    result.absolute? and return result

  end
  ap result
  result

end


def +( other )

  other.kind_of?( self.class )  or  other = self.class.new( other )
  self.class.new( plus( @path, other.to_path ) )

end



def touch( subPath = '', **options )

	path = @path
	ret  = self

	if directory?

		ret  = join subPath
		path = ret.to_path

	end

	FileUtils.touch( path, **options )

	ret

end



end # class  Pathname
end # module Fs
end # module TidBits
