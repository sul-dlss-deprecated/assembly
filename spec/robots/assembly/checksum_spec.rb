describe Assembly::Checksum do
  
  it "is a kind of LyberCore::Robots::Robot" do
    r = Assembly::Checksum.new
    r.should be_a_kind_of LyberCore::Robots::Robot 
    r.process_item('aa123bb1234')
  end
  
  it "should be able to call process_item()" do
    r = Assembly::Checksum.new
    v = false
    lambda { v = r.process_item('aa123bb1234') }.should_not raise_error
    v.should == true
  end
  
end
