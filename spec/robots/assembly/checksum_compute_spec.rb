require 'spec_helper'

describe Assembly::ChecksumCompute do

  before :each do
    @druid='aa222cc3333'
    setup_work_item(@druid)
    Dor::Assembly::Item.stub(:new).and_return(@assembly_item)
    @r = Assembly::ChecksumCompute.new(:druid=>@druid)
  end
    
  it "should be a LyberCore::Robots::Robot" do
    @r.should be_a_kind_of LyberCore::Robots::Robot 
  end

  it "should compute checksums for type=item" do
    setup_assembly_item(@druid,:item)    
    @assembly_item.should_receive(:is_item?)
    @assembly_item.should_receive(:load_content_metadata)
    @assembly_item.should_receive(:compute_checksums)
    @r.process_item(@work_item)
  end

  it "should not compute checksums for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only=true   
    setup_assembly_item(@druid,:set)         
    @assembly_item.should_receive(:is_item?)
    @assembly_item.should_not_receive(:load_content_metadata)
    @assembly_item.should_not_receive(:compute_checksums)
    @r.process_item(@work_item)
  end

  it "should compute checksums for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only=false       
    setup_assembly_item(@druid,:set)  
    @assembly_item.should_not_receive(:is_item?)    
    @assembly_item.should_receive(:load_content_metadata)
    @assembly_item.should_receive(:compute_checksums)
    @r.process_item(@work_item)
  end
  
end
