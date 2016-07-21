require 'pathname'


module TidBits
module Fs

class Path < Pathname


# Make a new Fs::Path object.
#
# @param path [Object.respond_to?( :to_path )] The path, may be any object that responds to #to_path. Defaults to the current working directory.
#
# @return [TidBits::Fs::Path] The new instance.
#
def self.new path = self.pwd

	super path.to_path

end


def self.pwd

	# When the current working directory gets deleted, things go pear shaped.
	# Dir.pwd will throw an exception and even `pwd` will choke. In that case
	# just set the old pwd to the users home dir.
	#
	pwd = ''

	begin

		pwd = Dir.pwd

	rescue Errno::ENOENT

		Dir.chdir
		pwd = Dir.pwd

	end

	pwd.path

end



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

	exist? or return

	require 'fileutils'

	FileUtils.remove_entry_secure( @path, force )

end


# Joins the given paths onto self to create a new Path object. Does not access the filesystem.
#
# @example Usage
#   "/usr".path.join 'bin', 'ruby' # Fs::Path:/usr/bin/ruby
#                                  # is the same as
#   "/usr".path + "bin/ruby"       # Fs::Path:/usr/bin/ruby
#
# @param  pieces [Object.respond_to?( :to_path )] One or more pieces to add to the path.
#
# @return A Fs::Path to the new location.
#
def join( *pieces )

  pieces.unshift self

  result = pieces.pop
  result.kind_of?( self.class )  or  result = self.class.new( result )

  result.absolute? and return result

  pieces.reverse_each do |arg|

    arg.kind_of?( self.class )  or  arg = self.class.new( arg )
    result = arg + result

    result.absolute? and return result

  end

  result

end


# Joins the give path onto self to create a new Path object. Does not access the filesystem.
#
# @example Usage
#   "/usr".path.join 'bin', 'ruby' # Fs::Path:/usr/bin/ruby
#                                  # is the same as
#   "/usr".path + "bin/ruby"       # Fs::Path:/usr/bin/ruby
#
# @param  other [Object.respond_to?( :to_path )] A pieces to add to the path.
#
# @return A Fs::Path to the new location.
#
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


def chdir &block

	old    = self.class.pwd
	result = Dir.chdir dirname

	block_given? or return result

	result = yield Pathname.pwd

	Dir.chdir old

	result

end



end # class  Pathname
end # module Fs
end # module TidBits
