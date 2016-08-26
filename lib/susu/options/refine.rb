Susu.refine( binding, :hash )

module Susu
module Options
module Refine


refine Hash do

	# Having it on top of the file alone won't do
	#
	Susu.refine( binding, :hash )


	def to_settings

		Settings.new self

	end


	def respond_to_options? name, include_all = false

		respond_to_susu?( name, include_all ) and return true

		[

			:to_settings

		].include? name.to_sym

	end

	alias :respond_to_before_options? :respond_to?
	alias :respond_to?                :respond_to_options?

end # refine Hash


# TODO: Find a way to do this with a refinement, but calling super in a refinement seems
# to call the refined class, which is exactly what we don't want... Hash.instance_method
# does not work either.
#
# refine Hashie::Mash do
#
class Hashie::Mash

	def dig( *keys )

		super( *keys.map { |key| convert_key key } )

	end

end # refine Hashie::Mash


end # module Refine
end # module Refine
end # module Susu
