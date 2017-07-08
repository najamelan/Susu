using Susu.refines

module Susu
module DataStruct


# A grid represents a two-dimensional data structure.
#
class Grid


	# beware of change after use
	#
	attr_accessor :default


def initialize sizex = 0, sizey = 0, default = nil

	@default = default
	@data    = [[]]

	self.size = sizex, sizey

end



# Shallow copies another grid. The actual elements in the grid are only references, so point to the same object.
#
# @example
#
#   g = Grid.new
#   g[ 0, 0 ] = 'a'
#
#   f = Grid.new.copy g
#
def copy original

	@default = original.default
	@data    = original.rows.map( &:to_a ).to_a

	self

end



# Shallow copies another grid. The actual elements in the grid are only references, so point to the same object.
#
# @example
#
#   g = Grid.new
#   g[ 0, 0 ] = 'a'
#
#   f = g.dup
#
def dup

	self.class.new.copy self

end



# Get the element of a specific grid position. Can also take an array of coordinates instead of the
# first two parameters.
#
# @param x    [int] The size of the X-axis.
# @param y    [int] The size of the Y-axis.
#
# @return [any] The element found on this location or nil if the position lays outside the grid boundaries.
#
def [] *coords

	x, y = Array.spit coords

	sx, sy = size

	x > sx - 1 and return nil
	y > sy - 1 and return nil

	# Direct acces is reversed, because we want to keep an intuitive approach to x being the horizontal and
	# y being the vertical axis. This also means looping and to_s are more intuitive.
	#
	@data[ y ][ x ]

end



# Inserts an element in the grid at a given position. Will grow the grid if needed.
# Can also take an array of coordinates instead of the first two parameters.
#
# TODO: allow taking arrays to set a range, and taking other grids with two ranges.
#
# @param x    [int] The size of the X-axis.
# @param y    [int] The size of the Y-axis.
# @param elem [any] The element to be inserted.
#
# @return [any] The element that was inserted.
#
def []= *coords, elem

	 x,  y = Array.spit coords
	sx, sy = size

	newX = [ x + 1, sx ].max
	newY = [ y + 1, sy ].max

	self.size = newX, newY

	@data[ y ][ x ] = elem

end



# The size of the grid as number of elements in [ x, y ]
#
# @return [Array[ x, y ] ]
#
def size

	x = @data[ 0 ].size

	# If the inner array is of size zero, there are no elements in the grid.
	#
	y = x.zero?  ?  0  :  @data.size

	[ x, y ]

end



# Sets the size of the grid. If reduced, elements will be dropped.
# If expanded, the default value will be inserted in the new cells. Can also take an array of coordinates instead of the
# two separate parameters.
#
# @param x      [int]           The size of the X-axis.
# @param y      [int]           The size of the Y-axis.
#
# @return self
#
def size= *coords

	x, y = Array.spit coords


	if x == 0 && y == 0

		clear
		return

	end


	s = @data.size

	case

		when s < y; @data[ s, y - s ] = Array.new( y - s ) { [] }
		when s > y; @data             = @data[ 0, y ]

	end


	@data.map! do |row|

		s = row.size

		case

			when s == x; row
			when s  < x; row[ s, x - s ] = Array.new( x - s, @default ); row
			when s  > x; row[ 0, x     ]

		end

	end

	self

end



# Empties the grid.
#
# @return self
#
def clear

	@data = [[]]
	self

end



# Returns a new array containing all elements of the grid for which the given block returns a true value.
#
# return [Enumerator|Array] An enumerator on self or an array of the selected elements if a block is given
#
def select

	block_given? or return self.to_enum( __method__ ) { s = size; s.first * s.last  }


	out = []

	each do |elem|

		yield( elem )  and  out << elem

	end

	out


end



# Returns a new array containing all elements of the grid for which the given block returns a false value.
# The ordering of non-rejected elements is maintained.
#
# return [Enumerator|Array] An enumerator on self or an array of the elements that haven't been rejected if a block is given
#
def reject

	block_given? or return self.to_enum( __method__ ) { s = size; s.first * s.last  }


	out = []

	each do |elem|

		yield( elem )  or  out << elem

	end

	out


end



# Returns an enumerator over the rows of the grid. A column is the collection of elements that share the same X coordinate.
#
# If a block is given, it will be passed an enumerator over the elements of the column.
#
# @return [Enumerator/Grid] If no block is given, return an enumerator on self, otherwise return self.
#
def cols

	block_given? or return self.to_enum( __method__ ) { size.first  }

	( 0...size.first ).each do |x|

		yield @data.map( &x.to_proc ).to_enum

	end

	self


end



# Returns an enumerator over the rows of the grid. A row is the collection of elements that share the same Y coordinate.
#
# If a block is given, it will be passed an enumerator over the elements of the row.
#
# @return [Enumerator/Grid] If no block is given, return an enumerator on self, otherwise return self.
#
def rows

	block_given? or return self.to_enum( __method__ ) { size.last  }

	# There is always an empty row
	#
	@data.first.empty? and return self


	@data.each do |row|

		# Don't expose internal data structures, hence to_enum
		#
		yield row.to_enum

	end

	self


end



# Loop through all cells of the grid.
#
# Will walk the x-axis first and then the y-axis
#
# @return [Enumerator/Grid] If no block is given, return an enumerator on self, otherwise return self.
#
def each

	block_given? or return self.to_enum { s = size; s.first * s.last  }


	@data.each do |row|

		row.each { |cell| yield cell }

	end

	self


end



# Loop through all cells of the grid.
#
# Will walk the x-axis first and then the y-axis. Will yield elem, x, y
#
# @return [Enumerator/Grid] If no block is given, return an enumerator on self, otherwise return self.
#
def each_with_coord

	block_given? or return self.to_enum( __method__ ) { s = size; s.first * s.last  }


	@data.each_with_index do |row, y|

		row.each_with_index { |cell, x| yield cell, x, y }

	end

	self

end



def map!

	block_given? or return self.to_enum( __method__ ) { s = size; s.first * s.last  }


	@data.each_with_index do |row, y|

		row.each_with_index { |cell, x| self[ x, y ] = yield cell }

	end

	self

end



# Invokes the given block once for each element of self. Creates a new array containing the values returned by the block.
# If no block is given, an Enumerator is returned instead.
#
# @return [Enumerator/Grid] If no block is given, return an enumerator on self, otherwise return a new grid.
#
def map &block

	block_given? or return self.to_enum( __method__ ) { s = size; s.first * s.last  }

	dup.map!( &block )

end



def to_s

	out = @data.map { |row| row.inspect }

	out.join "\n"

end



end # class  Grid
end # module DataStruct
end # module Susu
