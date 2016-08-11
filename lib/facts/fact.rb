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



attr_reader   :depend, :state, :status, :params, :sm, :address, :conditions, :operation
attr_accessor :fixedAny



def initialize( **opts )

	super

	init

	# This must survive reset, because we call reset if we need to re-analyze realite,
	# but then we won't know whether we fixed things or not unless we store it here.
	#
	@fixedAny = false

end



def init

	@mustDepend    = Array.eat( options.mustDepend   )
	@depends       = Array.eat( options.dependOn     )
	@metas         = Array.eat( options.metas        )
	@factPool      = Array.eat( options.factPool   )


	@log           = Logger.new( STDERR )
	@log.progname  = self.class.name

	@indexKeys     = Array.eat( options.indexKeys )

	@sm            = options.stateMachine || StateMachine.new
	@address       = createAddress
	@params        = createParams
	@desire        = @sm.desire!      @address
	@conditions    = @sm.conditions!  @address

	@facts         = @sm.facts
	@facts.set       @address, self

	@state         = createState

end


protected :reset
def reset

	super

	@depends   .each { |dep      | dep .reset }
	@conditions.each { |key, cond| cond.reset }

end



def self.createAddress( **opts )

	opts = self.options.deep_merge( opts )
	opts.indexKeys.map { |key| opts[ key ] }.unshift self.name

end

def createAddress; self.class.createAddress( options ) end



# create a state object from options, only setting expect
#
def createState( opts = options )

	state = TidBits::Options::Settings.new

	# Only take actual tests
	#
	opts.

		select { |opt| ! options.metas .include? opt }.
	   select { |opt| ! options.params.include? opt }.

	   each do | key, value |

			state[ key ] = { expect: value }
			addCondition( key, value )

	   end

	state

end


def addCondition( name, value )

	if @desire[ name ] && @desire[ name ] != value

		raise "Conflicting wanted states for: #{@address[ name ].ai}
		       desire: #{ value }, but value already present is:
		       desire: #{ @desire[ name ]}.
				"

	else

		@desire[ name ] = value

	end


	klass = Object.const_get( options.conditions ).const_get( name.to_s.capitalize! )
	address = @address.dup << name

	@conditions[ name ] and  raise "The condition already exists: #{address.ai}"

	@conditions[ name ] = klass.new( **options.dup, address: address, stateMachine: @sm )


end



def analyze

	analyzed?              and  return analyzePassed?

	operating? or super

	runDepends( :analyze )  or  return analyzeFailed

	@conditions.values.map( &:analyze ).all? ?

		  analyzePassed
		: analyzeFailed

end



def check

	checked?             and  return checkPassed?

	operating? or super

	analyze               or  return false
	runDepends( :check )  or  return checkFailed


	@conditions.values.map( &:check ).all? ?

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

	@conditions.values.map( &:fix )

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
def dependOn( klass, args, **opts )

	opts = opts.to_settings

	result = recycleDepend?( :dep, [], klass, args, **opts )  and  return result

	if result = recycleDepend?( :pool, [], klass, args, **opts )

		result.equal?( self )  or  @depends.push result
		return result

	end

	opts.factPool = Array.eat( opts.factPool )
	opts.factPool += [self] + @depends
	@depends.push klass.new( **args, **opts )

	@depends.last

end



# type == :dep Check in our dependency chain if a dependency that is a superset of this has already been
# depended on. This prevents useless creation of Facts that check the same things over
# and over again.
#
# type == :pool Check in the pool of available facts to see whether there is one exactly like the
# depend we need. In this case we will depend on it.
#
def recycleDepend?( type, visited = [], klass, args, **opts )

	visited.include? object_id and return false
	visited.push object_id


	if type == :pool

		@factPool.each do |fact|

			f = fact.recycleDepend?( type, visited, klass, args, **opts ) and return f

		end

	end


	@depends.each do |fact|

		f = fact.recycleDepend?( type, visited, klass, args, **opts ) and return f

	end


	klass == self.class  or  return false

	otherState = createState( self.class.options.deep_merge opts  )

	case type

		when :pool; stateComp = otherState      ==  createState
		when :dep ; stateComp = otherState.subset?( createState )

		else raise ArgumentError.new "Fact#recycleDepend? only accepts :pool or :dep as type parameter. Got #{type}"

	end

	args == params && stateComp  and  return self

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
