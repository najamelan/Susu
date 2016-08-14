
module Susu
module Options

class Config

attr_reader :parsedFiles


def initialize( default: [], userset: [], runtime: [] )

	@calledFrom  ||= caller_locations.first.absolute_path
	@parsedFiles   = []

	@defaultInputs, @defaultIncludes = processInputs( default )
	@usersetInputs, @usersetIncludes = processInputs( userset )
	@runtimeInputs, @runtimeIncludes = processInputs( runtime )

	@default = (                    @defaultInputs                    ).reduce( &:deep_merge ) || Settings.new
	@userset = ( @defaultIncludes + @usersetInputs + @usersetIncludes ).reduce( &:deep_merge ) || Settings.new
	@runtime = (                    @runtimeInputs + @runtimeIncludes ).reduce( &:deep_merge ) || Settings.new

	@options = @default.deep_merge( @userset ).deep_merge( @runtime )

end


# Put options on a class. It will create a settings and an options object on your class with
# the following layout:
#
#  - settings.cfgObj  => A reference to this Susu::Options::Config object.
#
#  - settings.default => usually application defaults that ship with the app
#  - settings.userset => extra configuration files from /etc or the home directory
#  - settings.runtime => anything you want to change on runtime
#
#  - options          => a deep merge of the 3 settings above.
#
# If a class is a subclass of another class that
#
# @param  klass       [Class/Module] The class onto which to put settings.
# @param  path        [Symbol, ...]  A list of symbols representing the path within the total options you want to use.
#                                    Usually when classes can be configured, you only want them to have a subset.
# @param  inclModule  [Boolean]      Whether to include a module that allows an instance of this class to call
#                                    `setupOptions( runtime )` in order to have it's own options object.
# @param  inherit     [Boolean]      Whether to inherit options from superclass (own options will override with deep_merge).
#
# @return self
#
# @example Usage:
#   # It will dig into the entire options to retrieve options[ :Data ][ :Xml ] so this class
#   # only considers this subset as their options.
#   #
#   configObj.setup( Data::Xml, :Data, :Xml )
#
#   configObj.setup( App ) # The app object gets everything.
#
#   # On your classes you can access options as:
#   #
#   App.options.Data.Xml == Data::Xml.options
#
# @see Configurable Configurable: the module that inclModule parameter refers to.
#
def setup( klass, *path, inclModule: true, inherit: true, sanitizer: nil, validator: nil )

	settings = Settings.new

	settings.default = @default.dig( *path ) || Settings.new
	settings.userset = @userset.dig( *path ) || Settings.new
	settings.runtime = @runtime.dig( *path ) || Settings.new
	opts             = @options.dig( *path ) || Settings.new


	sup = klass.superclass

	if inherit && sup.respond_to?( :settings ) && sup.settings.respond_to?( :cfgObj )

		 settings =  sup.settings.deep_merge settings
		 opts     =  sup.options .deep_merge opts

	end


	settings.cfgObj  = self

	[ settings.default, settings.userset, settings.runtime, opts ].each do |h|

		sanitizer and h._sanitizer_ = sanitizer
		validator and h._validator_ = validator

	end


	klass.extend settings.to_module( 'settings' )
	klass.extend opts    .to_module( 'options'  )

	inclModule and klass.include Configurable

	klass.singleton_methods.include?( :class_configured ) and klass.class_configured( self )

	self

end



protected


def processInputs inputs

	inputs   = Array.eat( inputs )
	output   = []
	includes = []
	tmpIncls = []
	from     = @calledFrom

	inputs.each do |input|

		# If it's a file
		#
		if input.kind_of?( Hash )

			input = input.to_settings

		else

			input = filename2array( input, @calledFrom )
			from  = input.first

			input.map!( &method( :parseFile) )

		end

		# Since input may now be a directory listing, make sure it's an array and loop over it.
		#
		input = Array.eat( input )

		input.each do |elem|

			[ output, tmpIncls ].nest_concat! extractIncludes( elem, from )

		end

	end


	while tmpIncls.length > 0

		out, tmpIncls = processInputs tmpIncls

		includes += out

	end

	includes.flatten!
	return output, includes

end



def filename2array file, from

	file.respond_to?( :to_path ) or raise ArgumentError.new "Unsupported input type for Susu::Options::Config: #{file.ai} or path did not exist. Supported are Hash and subclasses or String/Pathname representing a file or a directory or something that resolves to a valid string path when answering to #to_path."

	file = file.to_path.path

	if ! file.exist?

		if file.relpath( from ).exist?

			file = file.relpath( from )

		else

			raise ArgumentError.new "Could not find configuration file: #{file.to_path} included from #{from.to_path}."

		end

	end

	out =  file.directory?  ?  file.glob( '**/*.yml' )  :  file

	out = Array.eat out
	out.flatten!
	return out

end


# Take the include key from each input and extract it..
# Delete the include key on the original hash
#
def extractIncludes inputs, from

	inputs   = Array.eat( inputs )
	includes = []

	inputs.each_with_index do |out, i|

		out.include  or  next

		incls = Array.eat( out.include )

		incls.each do |incl|

			includes += filename2array( incl, from )

		end

		inputs[ i ].delete :include

	end

	includes.flatten!
	return inputs, includes

end


# Parses the configuration files
#
# @param  [String|Array<String>] files File or directory to parse or an array of such
# @return [Susu::Options:Settings]
#
def parseFile path

	if @parsedFiles.include? path

		STDERR.puts "WARNING: Trying to include configuration path twice: [#{path}]. Skipping..."
		return nil

	end


	@parsedFiles << path
	Settings.load( path, reload: true )

end


end # Config
end # Options
end # Susu

