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
#                  self.directory? otherwise, it will be self.dirname + pattern.
#                  Pattern should not start with a slash, otherwise it would be considered an absolute path.
# @param  flags    The flags as in File::Constants, see Dir.glob
# @param  block    The block will receive the pathname of each found path as parameter.
#
# @return nil
#
def glob( pattern, flags = 0, &block )

	p = self
	p.directory? or p = p.dirname

	p = ( p + pattern ).to_path

	block_given?  or  return Dir.glob( p, flags ).map!( &:path )

	Dir.glob( p, flags ) do |found|

		yield found.path

	end

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

	file? and return dirname.mkpath( subPath, mode )

	make = join( subPath )

 	make.directory? and return make

 	FileUtils.mkpath( make.to_path )

	make

end


# Will create a directory. Target = `self.join subPath`.
#
# - If self is a file, make the directory in the directory of self.
# - If self is a directory, make the target inside the directory.
# - If target is an existing file, bail with exception
# - If target is an existing directory, do nothing.
#
# @param  [Path|String] subPath  The sub path to create relative to the path of self.
# @param  [FixNum]      mode     The permissions for the new directory.
#
# @return A Path object to the new directory.
#
def mkdir( subPath = '', mode = 0777 )

	file? and return dirname.mkdir( subPath, mode )

	make = join( subPath )

 	make.directory? and return make

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


# Returns an array of children of the Path.
#
# @param  options  The options accepted are :
#                  - dir:       true
#                  - file:      true
#                  - follow:    true
#                  - recursive: false
#
# @param  block    an optional block
#
# @return { description_of_the_return_value }
#
def children( dir: true, file: true, follow: true, recursive: false, &block )

	toddlers = super( dir )

	file   or toddlers.delete_if { |entry| entry.file? }

	block_given? and toddlers.map! do |entry|

		result = yield entry

		result == true                and next entry
		result.kind_of?( self.class ) and next result

		nil

	end.compact!


	recursive and toddlers +=

		toddlers.map do |path|

			!follow && path.link? and next []
			path.directory?        or next []

			path.children( dir: dir, file: file, follow: follow, recursive: recursive, &block )

		end.flatten


	return toddlers

end



end # class  Pathname
end # module Fs
end # module TidBits
