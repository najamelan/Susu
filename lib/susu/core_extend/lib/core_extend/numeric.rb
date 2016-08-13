class Numeric

	def to_bool

		!zero?

	end


	def to_human_size

		require 'active_support'
		require 'active_support/number_helper.rb'

		ActiveSupport::NumberHelper.number_to_human_size self

	end

	alias :humanSize :to_human_size

end

