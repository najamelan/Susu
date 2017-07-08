module Susu
module DataStruct

	extend Autoload

	@modules =
	{
		Grid: "#{ __dir__ }/datastruct/grid"
	}

	def self.config; Susu.config end

end # module DataStruct
end # module Susu
