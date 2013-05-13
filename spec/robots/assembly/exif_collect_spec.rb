describe Assembly::ExifCollect do
  
  it "should be a LyberCore::Robots::Robot" do
    r = Assembly::ExifCollect.new
    r.should be_a_kind_of LyberCore::Robots::Robot 
  end

  it "should collect exif for type=item" do
    
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::ExifCollect.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('item')
    r.assembly_item(druid).should_receive(:load_content_metadata)
    r.assembly_item(druid).should_receive(:collect_exif_info)
    r.process_item(@work_item)
  
  end

  it "should not collect exif for type=set" do
    
    druid='aa222cc3333'
    setup_work_item(druid)
    r = Assembly::ExifCollect.new(:druid=>druid)
    r.assembly_item(druid).stub(:object_type).and_return('set')
    r.assembly_item(druid).should_not_receive(:load_content_metadata)
    r.assembly_item(druid).should_not_receive(:collect_exif_info)
    r.process_item(@work_item)
  
  end
  
end
