require 'awesome_print'

def read_line_number( filename, number )

  return nil if number < 1
  line = File.readlines( filename )[ number-1 ]
  line ? line.strip : nil

end

def sap arg

	loc = caller_locations.first

	puts read_line_number( loc.absolute_path, loc.lineno ).gsub!( /sap +/, "#{Pathname(loc.path).basename}:#{loc.lineno} - " ) + ' ⇝ ' + arg.ai

end
