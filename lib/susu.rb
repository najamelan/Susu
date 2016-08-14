require_relative 'susu/refine'
require_relative 'susu/fs'
require_relative 'susu/options'

module Susu

	ALL_REFINES = <<-REFINES

		using Susu::Refine::Array
		using Susu::Refine::Hash
		using Susu::Refine::Module
		using Susu::Refine::Numeric
		using Susu::Fs::Refine
		using Susu::Options::Refine

	REFINES

end
