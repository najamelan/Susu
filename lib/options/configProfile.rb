
module TidBits
module Options

class ConfigProfile < Config



def initialize( profile: :default, default: [], userset: [], runtime: [] )

	@calledFrom   = caller_locations.first.absolute_path

	super( default: default, userset: userset, runtime: runtime )

	@profile = profile.to_sym || :default
	@profile == :include and raise "FATAL: The profile cannot be called [include]. Include is the only reserved name."

	@inheritance  = []


	@allDefault = @default
	@allUserset = @userset
	@allRuntime = @runtime
	@allOptions = @options

	resolveProfile

end



def resolveProfile

	profile = @profile

	while profile != :default

		@allOptions.dig( profile ) or STDERR.puts "WARNING: Config profile [#{profile}] tries to inherit from unexisting profile [#{profile}]."

		@inheritance.include? profile  and  raise "WARNING: Config profile [#{profile}] tries to inherit from profile [#{profile}] but [#{profile}] is already in the inheritance chain."

		@inheritance.unshift profile

		profile = profile

		profile = @allOptions.dig( profile, :inherit )
		profile or break
		profile = profile.to_sym

	end

	mergeProfiles

end



def mergeProfiles

	@inheritance or @inheritance = []
	@inheritance.unshift :default


	@default = Settings.new
	@userset = Settings.new
	@runtime = Settings.new
	@options = Settings.new


	@inheritance.each do |parent|

		# We will extract only the content of the profiles, without keeping the rest, so in the end
		# we will only keep the currently running profile. The original will be stored in @allDefault, etc.
		#
		@default.deep_merge!( @allDefault.dig( parent ) || Settings.new )
		@userset.deep_merge!( @allUserset.dig( parent ) || Settings.new )
		@runtime.deep_merge!( @allRuntime.dig( parent ) || Settings.new )
		@options.deep_merge!( @allOptions.dig( parent ) || Settings.new )

	end

	# ap @default
	# ap @userset
	# ap @runtime
	# ap @options

end



end # ConfigProfile
end # Options
end # TidBits

