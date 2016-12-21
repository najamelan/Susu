require 'date'

module Susu
module Refine
module Date

# TODO: unit testing and do we need .between?
#
refine ::Date do

	Susu.refine binding, :Time

# Allow comparing time and date objects
#
# A date will be considered as midnight of that day, so shall be smaller than almost any time on the same day.
#
def <=> other

	other.kind_of?( self.class )                                    and  return super
	other.kind_of?( ::Time     )  || other.respond_to?( :to_time )  and  return to_time <=> other

	super

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



end # refine ::Date

end # module Date
end # module Refine
end # module Susu

