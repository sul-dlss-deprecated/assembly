describe Assembly::Checksum do
  
  before(:each) do
    @druid = Druid.new 'aa111bb2222'
    @acs   = Assembly::Checksum.new
  end

  it "is a kind of LyberCore::Robots::Robot" do
    @acs.should be_a_kind_of LyberCore::Robots::Robot 
  end
  
  it "should be able to call process_item() and get true return" do
    @acs = Assembly::Checksum.new
    rv   = false
    lambda { rv = @acs.process_item(@druid) }.should_not raise_error
    rv.should == true
  end
  
end
