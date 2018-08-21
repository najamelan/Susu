require 'rubygems/package'

module Susu
module Refine
module TarReader


refine ::Gem::Package::TarReader do


# This allows reading tar files without having to test for gnu longlinks in your software.
# See: https://stackoverflow.com/questions/2078778/what-exactly-is-the-gnu-tar-longlink-trick
#
# @param [Proc] Requires a block
#
# @yields  [Hash] containing 3 elements:
#                 - full_name : The actual path
#                 - linktarget: the target if this is a symlink
#                 - entry     : the entry from the original TarReader
#
# Entries which are long links won't be yielded, instead their content will be in full_name or linktarget for
# the appropriate file.
#
# TODO support header.prefix
# TODO support returning an enumerator. Does not work because of the refinement, but probably
#      we can take the enumerator on each and filter it and return a lazy enum on that or something...
#
def gnu_each

	linkname = nil
	filename = nil


	each do |e|

		# This is a longlink
		#
		if e.header.name == '././@LongLink'

			e.header.typeflag == 'K'  and  next linkname = e.read.strip
			e.header.typeflag == 'L'  and  next filename = e.read.strip

			raise "We should never get here unless the tar file is corrupted or I missed some part of the standard"

		end

		# This is an entry with a path shorter than 100 chars
		#
		filename ||= e.full_name
		linkname ||= e.header.linkname

		yield( { full_name: filename, linktarget: linkname, entry: e } )

		filename = linkname = nil

	end

end


end # refine Gem::Package::TarReader

end # module TarReader
end # module Refine
end # module Susu
