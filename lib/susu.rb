require_relative 'susu/core_extend'
require_relative 'susu/fs'

module Susu

	ALL_REFINES = <<-REFINES

		using Susu::Fs::Refine
		using Susu::CoreExtend::RefineArray
		using Susu::CoreExtend::RefineHash
		using Susu::CoreExtend::RefineModule
		using Susu::CoreExtend::RefineNumeric

	REFINES

end
