require 'hashie'

module Susu
module Options

	autoload :Refine        , File.join( __dir__, 'options/refine'        )
	autoload :Configurable  , File.join( __dir__, 'options/configurable'  )
	autoload :Settings      , File.join( __dir__, 'options/settings'      )
	autoload :Config        , File.join( __dir__, 'options/config'        )
	autoload :ConfigProfile , File.join( __dir__, 'options/configProfile' )

end # module Options
end # module Susu


