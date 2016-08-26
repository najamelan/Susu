Susu.refine( binding, :hash )

module Susu
module Options
module Refine


refine Hash do

  def to_settings

    Settings.new self

  end

end # refine Hash


# TODO: Find a way to do this with a refinement, but calling super in a refinement seems
# to call the refined class, which is exactly what we don't want...
#
# refine Hashie::Mash do
#
class Hashie::Mash

  def dig( *keys )

    super( *keys.map { |key| convert_key key } )

  end

end # refine Hashie::Mash


end # module Refine
end # module Refine
end # module Susu
