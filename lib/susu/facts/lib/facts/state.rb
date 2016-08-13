module TidBits
module Facts

module State

def fresh?        ;  @state.include? :fresh          end

def analyzing?    ;  @state.include? :analyzing      end
def checking?     ;  @state.include? :checking       end
def fixing?       ;  @state.include? :fixing         end

def analyzePassed?;  @state.include? :analyzePassed  end
def checkPassed?  ;  @state.include? :checkPassed    end
def fixPassed?    ;  @state.include? :fixPassed      end

def analyzeFailed?;  @state.include? :analyzeFailed  end
def checkFailed?  ;  @state.include? :checkFailed    end
def fixFailed?    ;  @state.include? :fixFailed      end

def analyzed?;  @state.intersect? Set[ :analyzeFailed, :analyzePassed ] end
def checked? ;  @state.intersect? Set[ :checkFailed  , :checkPassed   ] end
def fixed?   ;  @state.intersect? Set[ :fixFailed    , :fixPassed     ] end

def operating?; @state.intersect? Set[ :analyzing, :checking, :fixing ]    end
def operation ; ( @state & [ :analyzing, :checking, :fixing ] ).to_a.first end

protected

def initialize( *a, &b ) super; @state = [ :fresh ].to_set; end

def analyze; operating? and raise " Already operating, state: #{@state.ai}"; @state << :analyzing; @state.delete :fresh; @state end
def check  ; operating? and raise " Already operating, state: #{@state.ai}"; @state << :checking ; @state.delete :fresh; @state end
def fix    ; operating? and raise " Already operating, state: #{@state.ai}"; @state << :fixing   ; @state.delete :fresh; @state end

def analyzePassed;  @state << :analyzePassed;  @state -= [ :fresh, :analyzing, :analyzeFailed ];  true  end
def checkPassed  ;  @state << :checkPassed  ;  @state -= [ :fresh, :checking , :checkFailed   ];  true  end
def fixPassed    ;  @state << :fixPassed    ;  @state -= [ :fresh, :fixing   , :fixFailed     ];  true  end

def analyzeFailed;  @state << :analyzeFailed;  @state -= [ :fresh, :analyzing, :analyzePassed ];  false  end
def checkFailed  ;  @state << :checkFailed  ;  @state -= [ :fresh, :checking , :checkPassed   ];  false  end
def fixFailed    ;  @state << :fixFailed    ;  @state -= [ :fresh, :fixing   , :fixPassed     ];  false  end


# Reset is used internally in order to recheck if the system has been changed.
# fixPassed is a way to verify whether changes to the system have been made,
# so it must survive reset.
#
def reset;  @state = [ :fresh ].to_set + ( @state & Set[ :fixPassed ] ) end


end # module State

end # module Facts
end # module TidBits
