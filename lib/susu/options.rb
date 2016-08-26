require 'hashie'

Susu.refine( binding, :module )

module Susu
module Options

	extend Autoload

	@modules =
	{
		Refine:         "#{ __dir__ }/options/refine"        ,
		Config:         "#{ __dir__ }/options/config"        ,
		ConfigProfile:  "#{ __dir__ }/options/configProfile" ,
		Configurable:   "#{ __dir__ }/options/configurable"  ,
		Settings:       "#{ __dir__ }/options/settings"
	}

	def self.config; Susu.config end

end # module Options
end # module Susu


