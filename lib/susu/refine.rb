
require 'active_support/core_ext/hash/deep_merge'

module Susu
module Refine

	autoload :Array  , File.join( __dir__, 'refine/array'   )
	autoload :Hash   , File.join( __dir__, 'refine/hash'    )
	autoload :Module , File.join( __dir__, 'refine/module'  )
	autoload :Numeric, File.join( __dir__, 'refine/numeric' )

end # module Refine
end # module Susu
