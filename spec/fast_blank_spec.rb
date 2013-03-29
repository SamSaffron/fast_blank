require 'fast_blank'

class ::String
  def blank2?
    self !~ /[^[:space:]]/
  end
end

describe String do
  it "works" do
    "".blank?.should == true
    " ".blank?.should == true
    "\r\n".blank?.should == true
    "\r\n\v\f\r\s\u0085".blank? == true

    # weird ass unicode crap
    #
    # 1680, 180e, 200B, FEFF is missing from blank?
    #
    "\u00A0
    \u2000\u2001\u2002\u2003\u2004\u2005
    \u2006\u2007\u2008\u2009\u200A\u202F
    \u205F\u3000
    ".blank?.should == true
  end
end
