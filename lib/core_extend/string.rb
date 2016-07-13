require 'pathname'


class String

	def path

		Pathname self

	end

end # class String
