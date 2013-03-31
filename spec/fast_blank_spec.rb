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

  end

  it "provides a parity with active support function" do
    (16*16*16*16).times do |i|
      c = i.chr('UTF-8') rescue nil
      if c
        "#{i.to_s(16)} #{c.blank_as?}".should == "#{i.to_s(16)} #{c.blank2?}"
      end
    end


    (256).times do |i|
      c = i.chr('ASCII') rescue nil
      if c
        "#{i.to_s(16)} #{c.blank_as?}".should == "#{i.to_s(16)} #{c.blank2?}"
      end
    end
  end
end
