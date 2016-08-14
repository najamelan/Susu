require_relative 'susu/core_extend'
require_relative 'susu/fs'
require_relative 'susu/options'

module Susu

	ALL_REFINES = <<-REFINES

		using Susu::CoreExtend::RefineArray
		using Susu::CoreExtend::RefineHash
		using Susu::CoreExtend::RefineModule
		using Susu::CoreExtend::RefineNumeric
		using Susu::Fs::Refine
		using Susu::Options::Refine

	REFINES

end
