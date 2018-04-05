require 'spec_helper'

describe Robots::DorRepo::Assembly::ExifCollect do
  before :each do
    @druid = 'aa222cc3333'
    allow(Dor::Assembly::Item).to receive(:new).and_return(@assembly_item)
    @r = Robots::DorRepo::Assembly::ExifCollect.new(:druid => @druid)
  end

  it "should collect exif for type=item" do
    Dor::Config.configure.assembly.items_only = true
    setup_assembly_item(@druid, :item)
    expect(@assembly_item).to receive(:is_item?)
    expect(@assembly_item).to receive(:load_content_metadata)
    expect(@assembly_item).to receive(:collect_exif_info)
    @r.perform(@assembly_item)
  end

  it "should not collect exif for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only = true
    setup_assembly_item(@druid, :set)
    expect(@assembly_item).to receive(:is_item?)
    expect(@assembly_item).not_to receive(:load_content_metadata)
    expect(@assembly_item).not_to receive(:collect_exif_info)
    @r.perform(@assembly_item)
  end

  it "should collect exif for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only = false
    setup_assembly_item(@druid, :set)
    expect(@assembly_item).not_to receive(:is_item?)
    expect(@assembly_item).to receive(:load_content_metadata)
    expect(@assembly_item).to receive(:collect_exif_info)
    @r.perform(@assembly_item)
  end
end
