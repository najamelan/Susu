require 'pathname'
require 'fileutils'

Susu.refine binding

module Susu
module Fs


class Path < Pathname


@pwds = []

class << self

	# Make a new Fs::Path object.
	#
	# @param path [Object.respond_to?( :to_path )] The path, may be any object that responds to #to_path. Defaults to the current working directory.
	#
	# @return [Susu::Fs::Path] The new instance.
	#
	def new path = pwd

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
	def pushd( path, &block )

		@pwds << pwd
		path = cd path

		block_given? or return path

		begin ; yield path
		ensure; popd
		end

	end



	def popd

		@pwds.length == 0 and

			raise "Current working dir stack is empty, please don't call Path.popd more than you called Path.pushd."

		cd @pwds.pop

	end



	def pwd

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



	def cd path, &block

		block_given? and return pushd( path, &block )

		Dir.chdir path.to_path

		path.kind_of?( self ) or path = new( path )

		path

	end

end



# Instance methods


# This will give you a full path, which will not depend on the cwd to operate on the files,
# and will not include the '.' and '..' entries.
#
def ls

	result = children( recurse: false ) { |e| ! e.hidden? }

	if block_given?

		result.each { |e| yield e }

	end

	result

end


# This will give you a full path, which will not depend on the cwd to operate on the files,
# and will not include the '.' and '..' entries.
#
def la

	result = children recurse: false

	if block_given?

		result.each { |e| yield e }

	end

	result

end

#-------------------------------------------------------------------------------
# Returns the last component of the path as a string
#
# Returns the last component of the filename given in file_name, which can be formed using both File::SEPARATOR and File::ALT_SEPARATOR
# as the separator when File::ALT_SEPARATOR is not nil.
#
# @param suffix [String] If suffix is given and present at the end of the file name, it is removed.
#
# @return [String] The last component of the path, eg. after the last slash
#
def basename( suffix = nil )

	suffix and return super.to_s

	super().to_s

end

alias :name :basename


# Runs Pathname.glob
#
# @param  pattern  The pattern will be created by doing self + pattern if
#                  self.directory? otherwise, it will be self.dirname + pattern.
#                  Pattern should not start with a slash, otherwise it would be considered an absolute path.
# @param  flags    The flags as in File::Constants, see Dir.glob
# @param  block    The block will receive the pathname of each found path as parameter.
#
# @return [array]  An array of Fs::Path objects if no block given, and the result of the last iteration of the block otherwise.
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



# Like Pathname#relative_path_from
#
def subpath( base )

	self.class.new relative_path_from( base.path )

end



# Will make a path, creating intermediate directories as needed.
#
# @param  subPath  The sub path to create relative to the path of self.
# @param  options  The options as take by FileUtils.mkpath (eg. mode, noop, verbose)
#
# @return A Path object to the new directory.
#
def mkpath( subPath = '', options = {} )

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

	exist? or return self

	require 'fileutils'

	FileUtils.remove_entry_secure( @path, force )

	self

end

alias :rm :rm_secure


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

	self.class.cd dirname, &block

end


# Returns an array of children of the Path. Extends Pathname#children with recursive functionality, the possibility
# to filter entries with a block, to follow symlinks or not.
#
# The order of the output is undefined, eg. files might not be returned in alphabetical order. Call `path.children.sort`
# if you need alphabetical output. If called on a file, the call will be forwarded to the parent directory.
#
# Returns hidden entries.
#
# Will raise Errno::ENOENT if the entry does not exist.
#
#
# @param  options  The options accepted are :
#                  - withDir:   prefix current path to results @see Pathname#children. Note that Pathname#children always
#                               sets withDir to false if the current path is '.',  default: true
#                  - follow:    follow symlinks            , default: false
#                  - recurse:   recurse into subdirectories, default: true
#
# @param  block    an optional block which will receive each entry as it is found. If the block returns trueish,
#                  the entry will end up in the list returned, if block returns a path object, the current entry
#                  will be replaced by this path object, and else the entry will be omitted.
#
#                  Note that when recursive is true, the block will receive each entry as it is found, so if the block
#                  doesn't return a directory, it will not be recursed into. You can use this to recurse selectively.
#
# @return [Array] The list of entries below the current path.
#
# TODO: test follow
#
def children( follow: false, recurse: true, withDir: true, &block )

	file? and return parent.children( follow: follow, recurse: recurse, withDir: withDir, &block )


	toddlers = super( withDir )

	block_given? and toddlers.map! do |entry|

		result = yield entry

		result.kind_of?( self.class ) and next result
		result                        and next entry

		nil

	end.compact!


	recurse and toddlers +=

		toddlers.map do |path|

			!follow && path.symlink? and next []
			path.directory?           or next []

			path.children( follow: follow, recurse: recurse, withDir: withDir, &block )

		end.flatten


	toddlers

end


# Copy the file or directory to a new location.
# Options: preserve noop verbose dereference_root remove_destination.
#
# @param  dst  [respond_to(:to_path)|Array<respond_to(:to_path)>] The destination(s). If destination
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

	# Shall we return an array at the end of the method?
	#
	arr = dst.kind_of?( Array )

	# Prepare the destinations to be sent to fileutils
	#
	dst = Array.eat( dst )

	# Turn them all to strings
	#
	dst = dst.map { |path| path.to_path }

	# Figure out which of the destinations are existing directories, cause content
	# will be copied inside of them.
	#
	dir = dst.map { |path| path.path.directory? }


	dst.each { |dest| FileUtils.cp_r( @path, dest, opts ) }


	# Decide what to return and convert to Fs::Path
	#
	dst = dst.map.with_index do |dest, i|

		dest = dest.path
		dir[ i ]  and  dest = dest/basename

		dest

	end


	# If we didn't receive an array, just return a single element
	#
	arr or dst = Array.spit( dst )

	dst

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



# Is an entry hidden on the filesystem?
#
# TODO: OS/FS independance
#
# @return boolean
#
def hidden?

	basename.start_with? '.'

end


def shellescape

	@path.shellescape

end



# Indicates whether a file or directory is empty
#
# Also counts hidden files for directories.
#
# TODO: Deal with permissions and raise Errno::EACCESS if we can't produce reliable results.
#
# @return [nil|boolean] Nil if the entry does not exist or we have no permissions to read it, true if entry is a directory and contains subentries,
#                       true if entry is a file and contains content. False otherwise.
#
def empty?

	exist? or return nil

	directory? and return la.count == 0
	file?      and return ! size?

end



# Empties a directory or a file. Will also remove hidden entries. Noop on files/dirs we have no permissions to access.
#
# TODO: Deal with permissions and raise Errno::EACCESS if we can't produce reliable results.
#
def empty

	exist? or return self

	directory? and la.each { |e| e.rm_secure }
	file?      and truncate( 0 )

	self

end



# Returns the contents of a file as a string, or a list of entries for a directory (does not return hidden files/folders).
#
# @return [Array<Susu::Fs::Path>|String] String if entry is a file, Array of Paths if entry is a directory.
#
def content

	exist? or return nil

	directory? and return ls

	read

end



# Conversions
#

# Returns a File object which can be used as a IO stream.
#
# @raises Errno::EISDIR
#
# @return File stream
#
def io

	directory? and raise Errno::EISDIR.new( "Cannot make an io stream on a directory" )

	File.new @path

end



end # class  Path
end # module Fs
end # module Susu
