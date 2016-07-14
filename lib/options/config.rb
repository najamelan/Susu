
module TidBits
module Options

class Config

attr_reader :parsedFiles

def initialize( defaultFiles, runtime = [] )

	@include     = []
	@parsedFiles = []

	@default = parse     defaultFiles
	@userset = deepParse @include.shift
	@runtime = parseRunt runtime
	@options = @default.deep_merge( @userset ).deep_merge( @runtime )

end


def setup( klass, *options, inclModule: true )

	settings = Settings.new

	settings.defaults = @default.dig( *options )
	settings.userset  = @userset.dig( *options )
	settings.runtime  = @runtime.dig( *options )

	klass.extend settings.to_module( 'settings' )

	klass.extend @options.dig( *options ).to_module( 'options'  )

	inclModule and klass.include Configurable

end




protected


def parseRunt inputs

	output = Settings.new

	[*inputs].each do |input|

		if input.kind_of? Hash

			output.deep_merge! input
			next

		end

		output.deep_merge! deepParse( input )

	end

	output

end



# This will parse all files and directories passed to it, and then check for the key
# include. If there are includes, parse them recursively.
#
def deepParse files

	config = parse files
	more   = @include.shift

	more and config.deep_merge! deepParse( more )
	config

end



# Parses the configuration files
#
# @param  [String|Array<String>] files File or directory to parse or an array of such
# @return [TidBits::Options:Settings]
#
def parse files

	files  = *files
	config = Settings.new


	if files.length == 1 && files.first.path.directory?

		files = Dir[ files.first.join '**/*.yml' ]

	end


	files.each do |file|

		file = file.path.realpath

		# TODO: save the location of the code that created this object and try relative path before failing.
		#
		if ! file.exist?

			raise LoadError.new "WARNING: Trying to load unexisting configuration file: #{ file }. Config files parsed so far: #{@parsedFiles.ai}"

			next

		end


		if file.directory?

			config.deep_merge! parse( file )
			next

		end


		if @parsedFiles.include? file

			STDERR.puts "WARNING: Trying to include configuration file twice: [#{file}]. Skipping..."
			next

		end


		loaded = Settings.load( file, reload: true )

		config.deep_merge! loaded
		@parsedFiles << file


		# We don't override included files, so different config files can specify different
		# includes, so it's not possible in one config file to specify that another included
		# file shouldn't be included.
		#
		[*loaded.include].each do |f|

			fincl = f.path

			if f.path.exist?

				@include << fincl

			elsif f.relpath( file ).exist?

				@include << f.relpath( file )

			else

				raise LoadError.new "Cannot find configuration file [#{f}] included from #{file}"

			end

		end

		config.delete :include

	end


	config

end


end # Config
end # Options
end # TidBits

