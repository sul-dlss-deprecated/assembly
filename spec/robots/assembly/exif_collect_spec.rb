require 'spec_helper'

describe Robots::DorRepo::Assembly::ExifCollect do

  before :each do
    @druid='aa222cc3333'
    setup_work_item(@druid)
    Dor::Assembly::Item.stub(:new).and_return(@assembly_item)
    @r = Robots::DorRepo::Assembly::ExifCollect.new(:druid=>@druid)
  end

  it "should collect exif for type=item" do
    Dor::Config.configure.assembly.items_only=true
    setup_assembly_item(@druid,:item)
    @assembly_item.should_receive(:is_item?)
    @assembly_item.should_receive(:load_content_metadata)
    @assembly_item.should_receive(:collect_exif_info)
    @r.perform(@work_item)
  end

  it "should not collect exif for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only=true
    setup_assembly_item(@druid,:set)
    @assembly_item.should_receive(:is_item?)
    @assembly_item.should_not_receive(:load_content_metadata)
    @assembly_item.should_not_receive(:collect_exif_info)
    @r.perform(@work_item)
  end

  it "should collect exif for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only=false
    setup_assembly_item(@druid,:set)
    @assembly_item.should_not_receive(:is_item?)
    @assembly_item.should_receive(:load_content_metadata)
    @assembly_item.should_receive(:collect_exif_info)
    @r.perform(@work_item)
  end


end
