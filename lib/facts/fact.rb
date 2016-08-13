require_relative 'status'
require_relative 'instance_count'
require_relative 'condition'

module TidBits
module Facts


class Fact

include Options::Configurable, Status, InstanceCount


# Yaml can't have symbols as rvalues
#
def self.sanitize key, value

	if [ :params, :metas, :indexKeys ].include? key

		value = Array.eat( value ).map!( &:to_sym )

	end

	return key, value

end



attr_reader   :depends, :status, :params, :sm, :address, :operation


def initialize( **opts )

	super

	init

	# This must survive reset, because we call reset if we need to re-analyze realite,
	# but then we won't know whether we fixed things or not unless we store it here.
	#
	@fixedAny = false

end



def init

	@depends       = Array.eat( options.dependOn )
	@metas         = Array.eat( options.metas    )

	@log           = Logger.new( STDERR )
	@log.progname  = self.class.name

	@indexKeys     = Array.eat( options.indexKeys )

	@sm            = options.stateMachine || StateMachine.new
	@address       = createAddress
	@params        = createParams

	@sm.facts( @address ) or @sm.facts.set( @address, [] )
	@sm.facts( @address ) << self

end


protected :reset
def reset

	super

	@depends  .each { |dep | dep .reset }
	conditions.each { |cond| cond.reset }

end



def self.createAddress( **opts )

	opts = self.options.deep_merge( opts )
	opts.indexKeys.map { |key| opts[ key ] }.unshift self.name

end

def createAddress; self.class.createAddress( options ) end



# create a list with the names of all conditions from options
#
def conditionList( opts = options )

	@conditionList and return @conditionList

	@conditionList = []

	# Only take actual tests
	#
	opts.

		select { |opt| ! options.metas .include? opt }.
	   select { |opt| ! options.params.include? opt }.

	   each do | key, value |

			@conditionList << key

	   end

	@conditionList.uniq!
	@conditionList.sort!
	@conditionList

end



def conditions

	@conditions and return @conditions

	# Make sure we create address in the state machine unless it already exists.
	#
	sm = @sm.conditions! @address

	@conditions = conditionList.map do |name|

		sm[ name ] and next sm[ name ]

		condition( name, options[ name ] )

	end

end



# Returns the named condition and creates it if it doesn't exist.
#
# @param  name   [Symbol] The name of the condition, will be searched in the statemachine at the address of the
#                         current fact.
# @param  value  [Object] The value that is desired, if the condition exists, this must be the same as the already
#                         wanted value.
# @param  opts   [TidBits::Options::Settings] Potential overrides for the fact options to send to the condition
#                                             When creating
#
# @return { description_of_the_return_value }
#
def condition( name, value = nil, opts = {} )

	address = @address.dup << name
	cond    = @sm.conditions( address )

	if cond

		value.nil? || cond.expect == value  or

			raise "Conflicting desired states for: #{address.ai}.
		          desire: #{ value.ai }, but wanted differently before: #{ cond.expect.ai }."

		return cond

	end

	value.nil? and raise ArgumentError.new "Cannot create condition #{name} with nil value."

	opts[ name ] = value
	opts         = options.deep_merge opts

	klass = Object.const_get( self.class.name ).const_get( name.to_s.capitalize! )
	@sm.conditions.set( address, klass.new( **opts.dup, address: address, stateMachine: @sm ) )

end



def analyze

	analyzed?              and  return analyzePassed?

	operating? or super

	runDepends( :analyze )  or  return analyzeFailed

	conditions.map { |cond| cond.fact = self; cond.analyze }.all? ?

		  analyzePassed
		: analyzeFailed

end



def check

	checked?             and  return checkPassed?

	operating? or super

	analyze               or  return false
	runDepends( :check )  or  return checkFailed


	conditions.map { |cond| cond.fact = self; cond.check }.all? ?

		  checkPassed
		: checkFailed

end



def fix

	fixed?  and  return fixPassed?

	# Calls Status#fix to change our state to fixing. Must be set before check so dependencies can be fixed.
	#
	operating? or super

	# If check passes, we didn't change the system, so don't set fixPassed
	#
	check  and  return true

	runDepends( :fix )  or  return fixFailed

	conditions.map { |cond| cond.fact = self; cond.fix }

	reset
	check

	checkPassed?  ?  fixPassed  :  fixFailed

end



def debug(   msg ) log( msg, lvl: :debug   ) end
def info(    msg ) log( msg, lvl: :info    ) end
def warn(    msg ) log( msg, lvl: :warn    ) end
def error(   msg ) log( msg, lvl: :error   ) end
def fatal(   msg ) log( msg, lvl: :fatal   ) end
def unknown( msg ) log( msg, lvl: :unknown ) end

def log( msg, lvl: :warn )

	options.quiet or @log.send lvl, msg

end



protected


def createParams

	params = TidBits::Options::Settings.new

	options.params.each do |key|

		params[ key ] = options[ key ]
		instance_variable_set "@#{key}", params[ key ]

		self.class.class_eval { attr_accessor key }

	end

	params

end



def runDepends( operation )

	@depends.map do |dep|

		ret = dep.send( operation )

		ret or warn  "#{self.class.name}: Dependency #{dep.class.name} #{dep.params.ai} failed operation: #{operation}."

		ret

	end.all?

end




# Add a dependency to our fact. The dependency won't be added if we already
# depend on a fact of the same type who's options are a subset of the one
# we're told to add.
#
def dependOn( klass, **opts )

	opts = opts.to_settings
	addr = klass.createAddress opts

	f = satisfyDependency?( klass, opts )

	if f

		@depends << f
		return f

	end


	@sm.facts( addr ) or @sm.facts.set( addr, [] )
	facts = @sm.facts( addr )

	f = facts.find { |fact| fact.options == opts }

	if f

		@depends << f
		return f

	end

	# Create it
	#
	@depends << klass.new( opts )
	@depends.last

end



def satisfyDependency?( klass, **opts )

	klass == self.class  &&  opts.subset?( options ) and return self

	@depends.lazy.each { |dep| f = dep.satisfyDependency?( klass, opts ) and return f }

	false

end



def < other

	self.class == other.class or return nil

	   params == other.params                        \
	&& createState.subset?( other.createState )

end



def > other

	self.class == other.class or return nil

	   params == other.params                        \
	&& createState.superset?( other.createState )

end



def == other

		self.class  == other.class          \
	&& params      == other.params         \
	&& createState == other.createState

end


end # class  Fact
end # module Facts
end # module TidBits
