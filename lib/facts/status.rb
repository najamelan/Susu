module TidBits
module Facts

module Status

def initialize( *a, &b ) super; @status = [ :fresh ].to_set; end

def analyzePassed;  @status << :analyzePassed;  @status -= [:fresh, :analyzeFailed ];  @status  end
def checkPassed  ;  @status << :checkPassed  ;  @status -= [:fresh, :checkFailed   ];  @status  end
def fixPassed    ;  @status << :fixPassed    ;  @status -= [:fresh, :fixFailed     ];  @status  end

def analyzeFailed;  @status << :analyzeFailed;  @status -= [:fresh, :analyzePassed ];  @status  end
def checkFailed  ;  @status << :checkFailed  ;  @status -= [:fresh, :checkPassed   ];  @status  end
def fixFailed    ;  @status << :fixFailed    ;  @status -= [:fresh, :fixPassed     ];  @status  end

def fresh?        ;  @status.include? :fresh  end
def analyzePassed?;  @status.include? :analyzePassed  end
def checkPassed?  ;  @status.include? :checkPassed    end
def fixPassed?    ;  @status.include? :fixPassed      end
def analyzeFailed?;  @status.include? :analyzeFailed  end
def checkFailed?  ;  @status.include? :checkFailed    end
def fixFailed?    ;  @status.include? :fixFailed      end

def analyzed?;  @status.intersect? [ :analyzeFailed, :analyzePassed ].to_set end
def checked? ;  @status.intersect? [ :checkFailed  , :checkPassed   ].to_set end
def fixed?   ;  @status.intersect? [ :fixFailed    , :fixPassed     ].to_set end

def reset;  @status = [ :fresh ].to_set  end


end # module Status

end # module Facts
end # module TidBits
