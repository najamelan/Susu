module Susu
module Refine
module String

refine ::String do


alias :strip_or_nil! :strip!

def strip!

	strip_or_nil!

	self

end


alias :rstrip_or_nil! :rstrip!

def rstrip!

	rstrip_or_nil!

	self

end


alias :lstrip_or_nil! :lstrip!

def lstrip!

	lstrip_or_nil!

	self

end



# @return [nil/String] The first character of the string or nil if empty.
#
def first; self[  0 ] end



# @return [nil/String] The first character of the string or nil if empty.
#
def last ; self[ -1 ] end



# Wrap text to a certain width
#
def wrap( width )

	dup.wrap! width

end



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



end # refine String


end # module String
end # module Refine
end # module Susu

