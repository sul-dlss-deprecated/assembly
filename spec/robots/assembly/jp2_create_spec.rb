describe Assembly::Jp2Create do
  
  it "should be a LyberCore::Robots::Robot" do
    r = Assembly::Jp2Create.new
    r.should be_a_kind_of LyberCore::Robots::Robot 
  end

  it "should create jp2 for type=item" do
    
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::Jp2Create.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('item')
    r.assembly_item(druid).should_receive(:load_content_metadata)
    r.assembly_item(druid).should_receive(:create_jp2s)
    r.process_item(@work_item)
  
  end

  it "should not create jp2 for type=set if configured that way" do
    
    Dor::Config.configure.assembly.items_only=true
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::Jp2Create.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('set')
    r.assembly_item(druid).should_not_receive(:load_content_metadata)
    r.assembly_item(druid).should_not_receive(:create_jp2s)
    r.process_item(@work_item)
  
  end

  it "should create jp2 for type=set if configured that way" do
    
    Dor::Config.configure.assembly.items_only=false
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::Jp2Create.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('set')
    r.assembly_item(druid).should_receive(:load_content_metadata)
    r.assembly_item(druid).should_receive(:create_jp2s)
    r.process_item(@work_item)
  
  end

  
end
