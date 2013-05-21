describe Assembly::ChecksumCompute do
  
  it "should be a LyberCore::Robots::Robot" do
    r = Assembly::ChecksumCompute.new
    r.should be_a_kind_of LyberCore::Robots::Robot 
  end

  it "should compute checksums for type=item" do
    
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::ChecksumCompute.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('item')
    r.assembly_item(druid).should_receive(:load_content_metadata)
    r.assembly_item(druid).should_receive(:compute_checksums)
    r.process_item(@work_item)
  
  end

  it "should not compute checksums for type=set if configured that way" do

    Dor::Config.configure.assembly.items_only=true        
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::ChecksumCompute.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('set')
    r.assembly_item(druid).should_not_receive(:load_content_metadata)
    r.assembly_item(druid).should_not_receive(:compute_checksums)
    r.process_item(@work_item)
  
  end

  it "should compute checksums for type=set if configured that way" do

    Dor::Config.configure.assembly.items_only=false        
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::ChecksumCompute.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('set')
    r.assembly_item(druid).should_receive(:load_content_metadata)
    r.assembly_item(druid).should_receive(:compute_checksums)
    r.process_item(@work_item)
  
  end
  
end
