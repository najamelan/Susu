module Susu
module Refine

	extend Autoload

	@modules =
	{
		Array:         "#{ __dir__ }/refine/array"    ,
		Hash:          "#{ __dir__ }/refine/hash"     ,
		Module:        "#{ __dir__ }/refine/module"   ,
		Numeric:       "#{ __dir__ }/refine/numeric"
	}

	def self.config; Susu.config end

end # module Refine
end # module Susu
