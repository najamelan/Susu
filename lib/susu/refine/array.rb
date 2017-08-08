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

		  self[ 0  ] = value
		: self[ -1 ] = value

end



# Powergrep. Adds extra functionnality to grep. When pattern is a Regexp and the element
# is not a string, but responds to #to_s, the pattern is matched against the outcome of #to_s.
# NilClass is an exception, because #to_s gives an empty string, which might match patterns
# while this is usually not intended.
#
# @param  pattern [Object that respond_to :===]
# @block  &block  [Block] If a block is given, each matching element is passed to the block
#                         And the return value of the block replaces the element in the array returned
#                         from pgrep.
#
# @return [Array] The list of matching elements. Compact is called on the result, so a block can return nil
#                 for elements that shouldn't appear in the outcome.
#
def pgrep pattern, &block

	pattern.kind_of?( Regexp ) or return grep( pattern, &block )

	map do |obj|

		work = !obj.kind_of?( String ) && !obj.kind_of?( NilClass ) && obj.respond_to?( :to_s ) ?

			  obj.to_s
			: obj

		pattern === work or next

		block_given? ?

			  yield( obj )
			: obj

	end.compact

end



alias :compact_orig! :compact!

def compact!

	compact_orig!

	self

end



alias :flatten_orig! :flatten!

def flatten!

	flatten_orig!

	self

end



alias :uniq_orig! :uniq!

def uniq! &block

	uniq_orig!( &block )

	self

end



# What with duplicate entries
# Are all elements in self present in other
#
def subset?   other; ( self - other ).count == 0 end
def superset? other;  other.subset? self         end




# Liberate objects from the array on each iteration. This allows the garbage collector to get rid of them faster.
# Not taking a &block parameter avoids creation of anonymous Proc objects.
#
def each!

	while count > 0

		yield( shift )

	end

end



end # refine ::Array




refine ::Array.singleton_class do

# Coerce an object to be an array. Any object that is not an array will become
# a single element array with object at index 0.
#
# coercing nil returns an empty array.
#
def eat( object )

  object.nil?             and return []
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



end # refine ::Array.singleton_class

end # module Array
end # module Refine
end # module Susu

