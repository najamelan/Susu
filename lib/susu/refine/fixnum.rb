module Susu
module Refine
module Fixnum

refine ::Fixnum do


	# Allow convient access to multi-dimensional array by accessing a specific column.
	# If you use this, be kind to your reader and add a little comment explaining what it does, as it's not a common construct.
	#
	# FIXME: This doesn't actually work as a refinement with the shorthand &1 because where to_proc is attempted won't have
	# the refinement, so you should call to_proc manually in code that has the refinement.
	#
	# @example
	#
	#   a = [ 'one' , 'two' , 'three'  ]
	#   b = [ 'one-', 'two-', 'three-' ]
	#   c = [ a, b ]
	#
	#   d = c.map &1
	#   ap d
	#
	#   # Output:
	#   # [
	#   #     [0] "two",
	#   #     [1] "two-"
	#   # ]
	#
	#   c.map &0 # is the same as c.map &:first
	#
	#   # Working from the back also works:
	#   #
	#   c.map &-1 # is the same as c.map &:last
	#
	def to_proc

		Proc.new do |arr|

			arr[ self ]

		end

	end


end # refine ::Fixnum

end # module Fixnum
end # module Refine
end # module Susu

