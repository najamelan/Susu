module Susu
module Fs

	extend Autoload

	@modules =
	{
		Refine: "#{ __dir__ }/fs/refine" ,
		Path:   "#{ __dir__ }/fs/path"
	}

	def self.config; Susu.config end


	module Facts

		extend Autoload

		@modules =
		{
			Path:  "#{ __dir__ }/fs/facts/path"
		}

		def self.config; Susu.config end

	end # module Facts

end # module Fs
end # module Susu
