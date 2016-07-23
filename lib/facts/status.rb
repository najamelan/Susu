module TidBits
module Facts

module Status

FRESH = 0x01
FAILA = 0x02
PASSA = 0x04
FAILC = 0x08
PASSC = 0x10
FAILF = 0x20
PASSF = 0x40

def initialize( *a, &b ) super; @status = FRESH; end

def passAnalyze;  @status |= PASSA;  @status &= ~FRESH;  @status &= ~FAILA  end
def passCheck  ;  @status |= PASSC;  @status &= ~FRESH;  @status &= ~FAILC  end
def passFix    ;  @status |= PASSF;  @status &= ~FRESH;  @status &= ~FAILF  end

def failAnalyze;  @status |= FAILA;  @status &= ~FRESH;  @status &= ~PASSA  end
def failCheck  ;  @status |= FAILC;  @status &= ~FRESH;  @status &= ~PASSC  end
def failFix    ;  @status |= FAILF;  @status &= ~FRESH;  @status &= ~PASSF  end

def fresh?        ;  @status & FRESH  !=  0  end
def passedAnalyze?;  @status & PASSA  !=  0  end
def passedCheck?  ;  @status & PASSC  !=  0  end
def passedFix?    ;  @status & PASSF  !=  0  end
def failedAnalyze?;  @status & FAILA  !=  0  end
def failedCheck?  ;  @status & FAILC  !=  0  end
def failedFix?    ;  @status & FAILF  !=  0  end

def analyzed?;  @status & FAILA  !=  0   ||   @status & PASSA  != 0   end
def checked? ;  @status & FAILC  !=  0   ||   @status & PASSC  != 0   end
def fixed?   ;  @status & FAILF  !=  0   ||   @status & PASSF  != 0   end

def reset;  @status = FRESH  end


end # module Status

end # module Facts
end # module TidBits
