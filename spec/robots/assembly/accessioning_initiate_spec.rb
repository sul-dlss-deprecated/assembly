
describe Assembly::AccessioningInitiate do
  
  it "should be a LyberCore::Robots::Robot" do
    r = Assembly::AccessioningInitiate.new
    r.should be_a_kind_of LyberCore::Robots::Robot 
  end

  it "should initiate accessioning for type=item" do
    RestClient.stub(:post) # don't actually make the RestClient calls, just assume they work
    
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::AccessioningInitiate.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('item')
    r.assembly_item(druid).should_receive(:initiate_accessioning)
    r.process_item(@work_item)
  
  end

  it "should initiate accessioning for type=set" do
    RestClient.stub(:post) # don't actually make the RestClient calls, just assume they work
    
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::AccessioningInitiate.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('set')
    r.assembly_item(druid).should_receive(:initiate_accessioning)
    r.process_item(@work_item)
  
  end
  
  it "should always initiate accessioning regardless of object type" do
    RestClient.stub(:post) # don't actually make the RestClient calls, just assume they work
    
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::AccessioningInitiate.new(:druid=>druid)
    r.assembly_item(druid).should_receive(:initiate_accessioning)
    r.process_item(@work_item)
  
  end

  
end
