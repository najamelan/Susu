module TidBits
module Facts

module Status

def initialize( *a, &b ) super; @status = [ :fresh ].to_set; end

def passAnalyze;  @status << :passA;  @status -= [ :fresh, :failA ]  end
def passCheck  ;  @status << :passC;  @status -= [ :fresh, :failC ]  end
def passFix    ;  @status << :passF;  @status -= [ :fresh, :failF ]  end

def failAnalyze;  @status << :failA;  @status -= [ :fresh, :passA ]  end
def failCheck  ;  @status << :failC;  @status -= [ :fresh, :passC ]  end
def failFix    ;  @status << :failF;  @status -= [ :fresh, :passF ]  end

def fresh?        ;  @status.include? :fresh  end
def passedAnalyze?;  @status.include? :passA  end
def passedCheck?  ;  @status.include? :passC  end
def passedFix?    ;  @status.include? :passF  end
def failedAnalyze?;  @status.include? :failA  end
def failedCheck?  ;  @status.include? :failC  end
def failedFix?    ;  @status.include? :failF  end

def analyzed?;  @status.intersect? [ :failA, :passA ].to_set end
def checked? ;  @status.intersect? [ :failC, :passC ].to_set end
def fixed?   ;  @status.intersect? [ :failF, :passF ].to_set end

def reset;  @status = [ :fresh ].to_set  end


end # module Status

end # module Facts
end # module TidBits
