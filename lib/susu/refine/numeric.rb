module Susu
module Refine
module Numeric

refine ::Numeric do

	def to_bool

		!zero?

	end


	def to_human_size

		require 'active_support'
		require 'active_support/number_helper.rb'

		ActiveSupport::NumberHelper.number_to_human_size self

	end

	alias :humanSize :to_human_size



	def respond_to_susu? name, include_all = false

	  respond_to_before_susu?( name, include_all ) and return true

	  [

	    :to_bool        ,
	    :to_human_size  ,
	    :humanSize      ,

	  ].include? name.to_sym

	end

	alias :respond_to_before_susu? :respond_to?
	alias :respond_to?             :respond_to_susu?


end # refine String

end # module Numeric
end # module Refine
end # module Susu

