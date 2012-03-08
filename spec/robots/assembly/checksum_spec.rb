describe Assembly::Checksum do
  
  it "should be a LyberCore::Robots::Robot" do
    r = Assembly::Checksum.new
    r.should be_a_kind_of LyberCore::Robots::Robot 
  end
  
end
