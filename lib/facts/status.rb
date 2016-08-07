module TidBits
module Facts

module Status

def fresh?        ;  @status.include? :fresh          end

def analyzing?    ;  @status.include? :analyzing      end
def checking?     ;  @status.include? :checking       end
def fixing?       ;  @status.include? :fixing         end

def analyzePassed?;  @status.include? :analyzePassed  end
def checkPassed?  ;  @status.include? :checkPassed    end
def fixPassed?    ;  @status.include? :fixPassed      end

def analyzeFailed?;  @status.include? :analyzeFailed  end
def checkFailed?  ;  @status.include? :checkFailed    end
def fixFailed?    ;  @status.include? :fixFailed      end

def analyzed?;  @status.intersect? [ :analyzeFailed, :analyzePassed ].to_set end
def checked? ;  @status.intersect? [ :checkFailed  , :checkPassed   ].to_set end
def fixed?   ;  @status.intersect? [ :fixFailed    , :fixPassed     ].to_set end

def operating?; @status.intersect? [ :analyzing, :checking, :fixing ].to_set end

protected

def initialize( *a, &b ) super; @status = [ :fresh ].to_set; end

def analyze;  operating? and return @status; @status << :analyzing;  @status.delete :fresh;  @status  end
def check  ;  operating? and return @status; @status << :checking ;  @status.delete :fresh;  @status  end
def fix    ;  operating? and return @status; @status << :fixing   ;  @status.delete :fresh;  @status  end

def analyzePassed;  @status << :analyzePassed;  @status -= [ :fresh, :analyzing, :analyzeFailed ];  true  end
def checkPassed  ;  @status << :checkPassed  ;  @status -= [ :fresh, :checking , :checkFailed   ];  true  end
def fixPassed    ;  @status << :fixPassed    ;  @status -= [ :fresh, :fixing   , :fixFailed     ];  true  end

def analyzeFailed;  @status << :analyzeFailed;  @status -= [ :fresh, :analyzing, :analyzePassed ];  false  end
def checkFailed  ;  @status << :checkFailed  ;  @status -= [ :fresh, :checking , :checkPassed   ];  false  end
def fixFailed    ;  @status << :fixFailed    ;  @status -= [ :fresh, :fixing   , :fixPassed     ];  false  end


# Reset is used internally in order to recheck if the system has been changed.
# fixPassed is a way to verify whether changes to the system have been made,
# so it must survive reset.
#
def reset;  @status = [ :fresh ].to_set + ( @status & [ :fixPassed ].to_set ) end


end # module Status

end # module Facts
end # module TidBits
