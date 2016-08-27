module Susu
module Refine
module Module

refine ::Module do

# Returns the last component of a Module name.
#
# @example Usage:
#
#   module X
#   class  Y
#
#      def initialize
#
#         p self.class.name      #=> X::Y
#         p self.class.lastname  #=> Y
#
#      end
#
#    end # class  Y
#    end # module X
#
def lastname

	name.split( '::' ).last

end



# Autoload equivalent of require_relative
#
def autoload_relative( name, path )

	autoload( name, File.expand_path( path, File.dirname( caller_locations.first.absolute_path ) ) )

end


end # refine Module

end # module Module
end # module Refine
end # module Susu
