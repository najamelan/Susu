module Susu
module Refine
module Time

# TODO: unit testing and do we need .between?
#
refine ::Time do


# Allow comparing time and date objects (or any other object that responds to #to_time)
#
# A date will be considered as midnight of that day, so shall be smaller than almost any time on the same day.
#
def <=> other

	!other.kind_of?( self.class ) && other.respond_to?( :to_time )  and  other = other.to_time

	super other

end



# Unfortunately overriding the spaceship doesn't suffice
#
def  < other; ( self <=> other ) == -1 end
def  > other; ( self <=> other ) ==  1 end
def == other; ( self <=> other ) ==  0 end
def <= other; ( self <=> other ) <=  0 end
def >= other; ( self <=> other ) >=  0 end


def between? min, max

	( self <=> min ) >= 0  &&
	( self <=> max ) <= 0

end



end # refine ::Time

end # module Time
end # module Refine
end # module Susu

