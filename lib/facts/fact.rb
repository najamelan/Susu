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



attr_reader :depend, :state, :status, :params, :sm, :address, :conditions, :operation



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
	@depend        = Array.eat( options.dependOn     )
	@metas         = Array.eat( options.metas        )
	@factPool      = Array.eat( options.factPool   )


	@log           = Logger.new(STDERR)
	@log.progname  = self.class.name

	@indexKeys     = Array.eat( options.indexKeys )

	@sm            = options.stateMachine || StateMachine.new
	@address       = createAddress
	@params        = createParams
	@state         = createState
	@desire        = @sm.desire!( @address )
	@conditions    = @sm.conditions.dig!( *@address )
	@facts         = @sm.facts

	@facts.set @address, self

	createDesire
	createConditions

end



def reset

	super

	@depend    .each { |dep      | dep .reset }
	@conditions.each { |key, cond| cond.reset }

end



def createAddress

	@indexKeys.map { |key| options[ key ] }.unshift self.class.name

end


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

	   end

	state

end


# put the state on the stateMachine
#
def createDesire

	@state.each do | key, value |

		if @desire[ key ] && desire[ key ] != value.expect

			raise "Conflicting wanted states for: #{@address[ key ].ai}
			       desire: #{ value.expect }, but value already present is:
			       desire: #{ @desire[ key ]}.
					"

		end

		@desire[ key ] = value.expect

	end

end



def createConditions

	@state.each do | key, value |

		klass = Object.const_get( options.conditions ).const_get( key.to_s.capitalize! )
		address = @address.dup << key

		@conditions[ key ] and  raise "The condition already exists: #{address.ai}"

		@conditions[ key ] = klass.new( **options, address: address, stateMachine: @sm)

	end

	@conditions

end



def fixedAny?

	@fixedAny and return true

	@depend.any? { |dep| dep.fixedAny? }

end



def analyze

	checkDepends  or  ( analyzeFailed; return false )

	@operation ||= :analyze

	analyzePassed?  and  return @status
	states = @conditions.map { |key, cond| cond.analyze }

	states.none? { |state| state.include? :analyzeFailed }  ?  analyzePassed : analyzeFailed

	@operation == :analyze and @operation = nil
	return analyzePassed? ? true : false

end



def check

	checkDepends  or  ( checkFailed; return false )

	@operation ||= :check

	analyzed? or analyze
	states = @conditions.map { |key, cond| cond.check }

	states.none? { |state| state.include? :checkFailed }  ?  checkPassed : checkFailed

	@operation == :check and @operation = nil
	return checkPassed? ? true : false

end



def fix

	fixDepends  or  ( fixFailed; return false )

	@operation ||= :fix

	checked?       or  check
	checkPassed?  and  ( fixPassed; return true )

	@conditions.map { |key, cond| cond.fix }

	if @conditions.any? { |key, cond| cond.fixed? }

		@fixedAny = true
		reset
		check

	end


	checkPassed? ?  fixPassed  :  fixFailed

	@operation == :fix and @operation = nil
	return fixPassed? ? true : false

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



def checkDepends

	@depend.each do | dep |

		!dep.checked?  and  dep.check

		if !dep.checkPassed?

			warn "#{self.class.name}: Dependency #{dep.class.name} #{dep.params.ai} failed."
			return false

		end

	end

	true

end



def fixDepends( update = false, **options )

	@depend.each do | dep |

		!dep.fixed?  and  dep.fix

		if !dep.fixPassed?

			warn "#{self.class.name}: Dependency #{dep.class.name} #{dep.params.ai} could not be fixed."
			return false

		end

	end

	true

end



# Add a dependency to our fact. The dependency won't be added if we already
# depend on a fact of the same type who's options are a subset of the one
# we're told to add.
#
def dependOn( klass, args, **opts )

	opts = opts.to_settings

	result = recycleDepend?( :dep, [], klass, args, **opts )  and  return result

	if result = recycleDepend?( :pool, [], klass, args, **opts )

		result.equal?( self )  or  @depend.push result
		return result

	end

	opts.factPool = Array.eat( opts.factPool )
	opts.factPool += [self] + @depend
	@depend.push klass.new( **args, **opts )

	@depend.last

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


	@depend.each do |fact|

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
