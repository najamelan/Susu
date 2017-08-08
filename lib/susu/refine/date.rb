require 'date'

module Susu
module Refine
module Date


refine ::Date do

	using Susu::Refine::Time

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

def between? min, max; self >= min  &&  self <= max end


end # refine ::Date



refine ::Date.singleton_class do

# Parses a date in the format of 'yyyy-mm-dd'
#
# This is 30% faster than Date.strptime and 60% faster than Date.iso8601 in ruby 2.3.3
#
# @example
#
#   n = 500000
#   date = '2025-03-25'
#
#   Benchmark.bm do |x|
#
#      x.report( 'Date.iso8601     ' ) { n.times do; a = Date.iso8601(       date ) end }
#      x.report( 'Date.strptime    ' ) { n.times do; a = Date.strptime(      date ) end }
#      x.report( 'Date.iso8601_orig' ) { n.times do; a = Date.iso8601_orig(  date ) end }
#      x.report( 'Date.parse       ' ) { n.times do; a = Date.parse(         date ) end }
#
#   end
#
# @param  [String] str The string to parse
# @return [Date]       The date object with the parsed date
#
alias :iso8601_orig :iso8601

def iso8601 str

	new( str[ 0, 4 ].to_i, str[ 5, 2 ].to_i, str[ 8, 2 ].to_i )

end

end # refine ::Date.singleton_class

end # module Date
end # module Refine
end # module Susu

