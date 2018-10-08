module Susu
module Refine
module String


# Regex used by the trimLines methods for leading whitespace.
#
LTRIM_PATTERN = /^[ \t]++/


# Regex used by the trimLines methods for trailing whitespace.
#
RTRIM_PATTERN = /[ \t]++$/




refine ::String do


# Store the original methods in more reasonable names:
#
alias :strip_or_nil!    :strip!
alias :rstrip_or_nil!   :rstrip!
alias :lstrip_or_nil!   :lstrip!
alias :gsub_or_nil!     :gsub!
alias :downcase_or_nil! :downcase!
alias :upcase_or_nil!   :upcase!

def strip!   ; strip_or_nil!   ; self end
def rstrip!  ; rstrip_or_nil!  ; self end
def lstrip!  ; lstrip_or_nil!  ; self end
def downcase!; downcase_or_nil!; self end
def upcase!  ; upcase_or_nil!  ; self end

def gsub!( *args, &block ) gsub_or_nil!( *args, &block ); self end




# Removes leading and trailing whitespace from each line in place.
#
# @return [String] self
#
def trimLines!

	gsub!( LTRIM_PATTERN, '' )
	gsub!( RTRIM_PATTERN, '' )

end



# Removes leading whitespace from each line in place.
#
# @return [String] self
#
def ltrimLines!; gsub!( LTRIM_PATTERN, '' ) end



# Removes trailing whitespace from each line in place.
#
# @return [String] self
#
def rtrimLines!; gsub!( RTRIM_PATTERN, '' ) end



# Returns a copy without leading and trailing whitespace.
#
# @return [String] A new string
#
def  trimLines; dup. trimLines! end



# Returns a copy without leading whitespace.
#
# @return [String] A new string
#
def ltrimLines; dup.ltrimLines! end



# Returns a copy without trailing whitespace.
#
# @return [String] A new string
#
def rtrimLines; dup.rtrimLines! end



# @return [nil/String] The first character of the string or nil if empty.
#
def first; self[  0 ] end



# @return [nil/String] The first character of the string or nil if empty.
#
def last ; self[ -1 ] end



# Wrap text to a certain width
#
def wrap( width ) dup.wrap! width end



# Wrap text to a certain width
#
def wrap!( width )

	width == 0  and  return self

	pattern = /

		# Match as many characters as possible up to width
		#
		(
			.{1,#{ width }}
		)

		# For the splitpoint to match it must fulfill these conditions:
		#
		(?:
			  (?:  [ \t]+|$\n? )  # Catch one or more whitespace chars, or the end of the line, or the end of the string.
			| (?<= [-,:;.)]    )  # OR, if there is no spaces or newline, we are still allowed to split right after -,:;.)
		)

		(?!  [:.,])   # The next character after the split should not be a colon or a dot or a comma.

	/x


	# The regular expression will add a newline if it matches the end of the string, so we need to remove it if there was no newline there before.
	#
	newline = last == "\n"

	gsub!( pattern, "\\1\n" )

	newline or chomp!

	self

end



# Returns the width in characters of the longest line of the string.
#
def width

	split( "\n" ).map( &:length ).max

end



end # refine String


end # module String
end # module Refine
end # module Susu

