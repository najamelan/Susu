module Susu

module Autoload

	def self.extended base

		base.instance_eval do

			@loaded  = Set.new
			@modules = {}

		end

	end



	def const_missing name

		if @modules.has_key? name

			require     @modules[ name ]
			@loaded.add name

			klass = const_get name
			klass.respond_to?( :configure ) && respond_to?( :config ) and klass.configure( config )

			return klass

		# TODO: When refering to a constant within a class, Ruby doesn't call const_missing on the enclosing modules
		#       which means we have to preload classes manually.

		else

			raise "Class not found: #{ name.to_s }."

		end

	end



	def configure config

		@loaded.each do |name|

			mod = const_get name
			mod.respond_to?( :configure ) and mod.configure( config )

		end

	end

end # module Autoload
end # module Susu
