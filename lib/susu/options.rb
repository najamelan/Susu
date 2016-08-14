require 'hashie'

using Susu::Refine::Module

module Susu
module Options

	autoload_relative :Refine        , 'options/refine'
	autoload_relative :Configurable  , 'options/configurable'
	autoload_relative :Settings      , 'options/settings'
	autoload_relative :Config        , 'options/config'
	autoload_relative :ConfigProfile , 'options/configProfile'

end # module Options
end # module Susu


