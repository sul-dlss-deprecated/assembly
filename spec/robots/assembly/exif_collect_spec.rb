describe Assembly::ExifCollect do
  
  it "should be a LyberCore::Robots::Robot" do
    r = Assembly::ExifCollect.new
    r.should be_a_kind_of LyberCore::Robots::Robot 
  end
  
end
