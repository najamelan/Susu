module Susu
module CoreExtend
module RefineNumeric

refine Numeric do

	def to_bool

		!zero?

	end


	def to_human_size

		require 'active_support'
		require 'active_support/number_helper.rb'

		ActiveSupport::NumberHelper.number_to_human_size self

	end

	alias :humanSize :to_human_size


end # refine String

end # module RefineNumeric
end # module CoreExtend
end # module Susu

