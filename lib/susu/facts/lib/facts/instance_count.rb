module TidBits
module Facts

module InstanceCount


	def initialize( *args, &block )

		super


		# Subclasses inherit the methods, but count won't be initialized
		#
		self.class.ancestors.each do | parent |

			! parent.methods.include?( :count ) and break

			parent.instance_eval do

				@count or @count = 0
				@count += 1

			end

		end

	end


	def self.included( base )

		base.singleton_class.send :attr_accessor, :count
		base.count = 0

	end

end


end # module Facts
end # module TidBits
