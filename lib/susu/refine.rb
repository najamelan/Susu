require_relative 'refine/global'

module Susu
module Refine

	extend Autoload

	@modules =
	{
		Array:    "#{ __dir__ }/refine/array"    ,
		Date:     "#{ __dir__ }/refine/date"     ,
		Hash:     "#{ __dir__ }/refine/hash"     ,
		Module:   "#{ __dir__ }/refine/module"   ,
		Numeric:  "#{ __dir__ }/refine/numeric"  ,
		String:   "#{ __dir__ }/refine/string"   ,
		Time:     "#{ __dir__ }/refine/time"
	}

	def self.config; Susu.config end

end # module Refine
end # module Susu
