require 'pathname'

eval Susu::ALL_REFINES, binding

module Susu
module Fs

class Path < Pathname

@pwds = []

alias :ls :entries

# Make a new Fs::Path object.
#
# @param path [Object.respond_to?( :to_path )] The path, may be any object that responds to #to_path. Defaults to the current working directory.
#
# @return [Susu::Fs::Path] The new instance.
#
def self.new path = self.pwd

	super path.to_path

end


# Push a new directory on the stack of current working dirs and change pwd to
# it.
#
# @param  path    The directory to become pwd
# @param  &block  When a block is given, execute it and then pop the working dir.
#
# @return Then new working dir as an Fs::Path or if a block is given, the result of the block.
#
def self.pushd( path, &block )

	@pwds << pwd
	cd       path

	block_given? or return path.path

	begin ; yield path.path
	ensure; popd
	end

end



def self.popd

	@pwds.length == 0 and raise "Current working dir stack is empty, please don't call Path.popd more than you called Path.pushd."
	cd @pwds.pop

end



def self.pwd

	# When the current working directory gets deleted, things go pear shaped.
	# Dir.pwd will throw an exception and even `pwd` will choke. In that case
	# just set the pwd to the users home dir.
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



def self.cd path

	Dir.chdir path.to_path

	path.kind_of?( self ) or path = self.new( path )

	path

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

	block_given?  or  return Dir.glob( p, flags ).map! { |str| str.path }

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

alias :/  :+
alias :[] :+



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


# Returns an array of children of the Path. Extends Pathname#children with recursive functionality, the possibility
# to filter entries with a block, to follow symlinks or not. The order of the output is undefined, eg. files might
# not be returned in alphabetical order. Call `path.children.sort` if you need alphabetical output.
#
# @param  options  The options accepted are :
#                  - withDir:   prefix current path to results @see Pathname#children. Note that Pathname#children always
#                               sets withDir to false if the current path is '.',  default: true
#                  - follow:    follow symlinks            , default: true
#                  - recursive: recurse into subdirectories, default: false
#
# @param  block    an optional block which will receive each entry as it is found. If the block returns true,
#                  the entry will end up in the list returned, if block returns a path object, the current entry
#                  will be replaced by this path object, and else the entry will be omitted.
#
#                  Note that when recursive is true, the block will receive each entry as it is found, so if the block
#                  doesn't return a directory, it will not be recursed into. You can use this to recurse selectively.
#
# @return [Array] The list of entries below the current path.
#
def children( follow: true, recursive: false, withDir: true, &block )

	toddlers = super( withDir )

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

			path.children( follow: follow, recursive: recursive, withDir: withDir, &block )

		end.flatten


	toddlers

end


# Copy the file or directory to a new location.
# Options: preserve noop verbose dereference_root remove_destination.
#
# @param  dst  [respond_to(:to_path)|Array(respond_to(:to_path))] The destination(s). If destination
#              is an existing directory, source shall be copied inside. If destination is an existing
#              file, it shall be replaced only if remove_destination is set. If parent directories
#              don't exist, they will be created.
#
# @param  opts         [hash] options to pass to FileUtils.cp_r
#
# @return [Fs::Path|Array(Fs::Path)] The destination(s) as Fs::Path or an array of such. If you have passed
#                                    in an array with one element, you will be returned an array.
#
# TODO: Unit testing and verifying and documenting the behaviour of FileUtils.cp_r.
#
def copy( dst, **opts )

	arr = dst.kind_of?( Array )
	dst = Array.eat( dst )
	dst = dst.map( &:to_path )

	dst.each { |dest| FileUtils.cp_r( @path, dest, opts ) }

	dst = dst.map do |dest|

		dest = dest.path
		dest.directory? and dest = dest/basename

	end

	!arr and dst = Array.spit( dst )

end

alias :cp :copy


# Move the file or directory to a new location. Wrapper around FileUtils.mv
# Options: force noop verbose.
#
# @param  dst   [respond_to(:to_path)] The destination.
#
# @param  opts  [hash]                 Options to pass to FileUtils.mv
#
# @return [Fs::Path] The destination as Fs::Path.
#
# TODO: Unit testing and verifying and documenting the behaviour of FileUtils.mv.
#
def move( dst, **opts )

	FileUtils.mv( self.to_path, dst.to_path, opts )

	dst.path

end

alias :mv :move


def rename newName

	newName = newName.path
	newName.absolute? or newName = self.dirname/newName

	move newName

	newName

end

end # class  Path
end # module Fs
end # module Susu
