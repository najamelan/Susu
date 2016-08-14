module Susu
module Refine
module Array

refine ::Array do


def nest_concat! other

	each_with_index { |arr, i| self[i].concat other[ i ] }

end



def nest_concat other

	d = map( &:dup )
	each_with_index { |arr, i| d[i].concat other[ i ] }

	d

end



def first= value

	self[ 0 ] = value

end



def last= value

	empty? ?

		  self.first = value
		: self[ -1 ] = value

end



def respond_to? name, include_all = false

	super and return true

	[

		:nest_concat   ,
		:nest_concat!  ,
		:first=        ,
		:last=

	].include? name.to_sym

end



class << ::Array
# Coerce an object to be an array. Any object that is not an array will become
# a single element array with object at index 0.
#
# coercing nil returns an empty array.
#
def eat( object )

  object.nil?              and return []
  object.kind_of?( self ) and return object

  [object]

end


# The opposite of Array.eat. If an array only contains one element, return the element.
# This allows to call a method with an array without having to splat on caller side.
# The method needs to splat their arguments on the parameter list.
#
# @example Usage
#
#   def some *path
#
#      path = Array.spit path
#
#      someHash.dig *path
#
#   end
#
#   some    :key1, :key2    # Will work
#   some  [ :key1, :key2 ]  # Will also work thanks to spit
#   some *[ :key1, :key2 ]  # Will work but no need to splat now.
#
def spit args

	args.kind_of?( self ) && args.length == 1  and  args = args.first

	args

end


end # class << Array


end # refine Array

end # module Array
end # module Refine
end # module Susu

