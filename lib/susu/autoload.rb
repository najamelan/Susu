module Susu

module Autoload

	def self.extended base

		base.instance_eval do

			@loaded  = Set.new
			@modules = {}

		end

	end



	# Allows to pass arrays of symbols to load several levels of modules and classes at once.
	#
	def const_get name, inherit = false

		if Array === name

			return name.reduce( self ) { |parent, wanted| parent.const_get( wanted, inherit ) }

		end

		super

	end



	# This will look in @modules of your module to load the files required for loading the constant.
	#
	def const_missing name

		if @modules.has_key? name

			require     @modules[ name ]
			@loaded.add name

			klass = const_get name
			klass.respond_to?( :configure ) && respond_to?( :config ) and klass.configure( config )

			return klass

		else

			super

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



# As long as https://bugs.ruby-lang.org/issues/2740 is not implemented, we need to monkey patch Class in order for the autoloading
# system to work when refering to a constant from within a class when that constant is defined in the nesting modules, but not yet
# loaded. Otherwise ruby will not call const_get or const_missing on the surrounding modules, so the autoload will not trigger.
#
# If you need to avoid the monkey patching, there is a workaround without monkey patching, which is to trigger
# the autoloading manually in the context of the correct module before using it from within a class:
#
# @example
#
#   # This module uses the Susu autoloading system.
#   #
#   module FruitBasket
#
#     # Autoload class Banana
#     #
#     Banana
#
#     class Apple
#
#        # Use Banana here because it will have been autoloaded now.
#        # Would raise a NameError exception if Banana was not manually loaded above and the monkey patch is not in use.
#        #
#        Banana.price = 99
#
#     end # class Apple
#
#   end # module FruitBasket
#
class Class

	def const_missing lost

		# ap "const_missing called for #{lost} in #{self.name}"

		begin

			return super

		rescue NameError => error

			context = name.split('::')

			# If there are no nesting modules, all of this makes no sense
			#
			context.count == 1 and raise error

			# Look for the name moving up in the nesting hierarchy
			#
			until context.empty?

				# First time this will remove the current class from the list, after that will allow us to walk up the nesting tree.
				#
				context.pop
				parts = context.clone

				# Try to resolve until we have the one we're looking for.
				#
				parts << lost

				begin

					klass = Module.const_get( parts.shift )
					klass = klass .const_get( parts.shift ) until parts.empty?

					klass.name.end_with?( "::#{ lost.to_s }" ) and return klass

				# If it isn't found at this level, it will raise, and we will move up to the next level.
				#
				rescue NameError
				end

			end

			# If we didn't find anything, raise the error from super
			#
			raise error

		end

	end

end
