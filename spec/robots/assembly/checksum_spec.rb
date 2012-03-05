describe Assembly::Checksum do
  
  before(:each) do
    @druid = Druid.new 'aa111bb2222'
    @acs   = Assembly::Checksum.new
  end

  it "is a kind of LyberCore::Robots::Robot" do
    @acs.should be_a_kind_of LyberCore::Robots::Robot 
  end
  
  # TODO: add a spec that invokes process_item.

end
