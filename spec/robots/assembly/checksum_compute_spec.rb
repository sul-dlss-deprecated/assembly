require 'spec_helper'

describe Robots::DorRepo::Assembly::ChecksumCompute do

  before :each do
    @druid='aa222cc3333'
    setup_work_item(@druid)
    allow(Dor::Assembly::Item).to receive(:new).and_return(@assembly_item)
    @r = Robots::DorRepo::Assembly::ChecksumCompute.new(:druid=>@druid)
  end

  it "should compute checksums for type=item" do
    setup_assembly_item(@druid,:item)
    expect(@assembly_item).to receive(:is_item?)
    expect(@assembly_item).to receive(:load_content_metadata)
    expect(@assembly_item).to receive(:compute_checksums)
    @r.perform(@work_item)
  end

  it "should not compute checksums for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only=true
    setup_assembly_item(@druid,:set)
    expect(@assembly_item).to receive(:is_item?).and_return(false)
    expect(@assembly_item).not_to receive(:load_content_metadata)
    expect(@assembly_item).not_to receive(:compute_checksums)
    @r.perform(@work_item)
  end

  it "should compute checksums for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only=false
    setup_assembly_item(@druid,:set)
    expect(@assembly_item).not_to receive(:is_item?)
    expect(@assembly_item).to receive(:load_content_metadata)
    expect(@assembly_item).to receive(:compute_checksums)
    @r.perform(@work_item)
  end

end
