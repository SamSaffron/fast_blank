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
      unless c.nil?
        "#{i.to_s(16)} #{c.blank_as?}".should == "#{i.to_s(16)} #{c.blank2?}"
      end
    end


    (256).times do |i|
      c = i.chr('ASCII') rescue nil
      unless c.nil?
        "#{i.to_s(16)} #{c.blank_as?}".should == "#{i.to_s(16)} #{c.blank2?}"
      end
    end
  end

  it "has parity with strip.length" do
    (256).times do |i|
      c = i.chr('ASCII') rescue nil
      unless c.nil?
        "#{i.to_s(16)} #{c.strip.length == 0}".should == "#{i.to_s(16)} #{c.blank?}"
      end
    end
  end

  it "treats \u0000 correctly" do
    # odd I know
    "\u0000".strip.length.should == 0
    "\u0000".blank_as?.should be_false
    "\u0000".blank?.should be_true
  end

end
