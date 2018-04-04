require 'spec_helper'

describe Robots::DorRepo::Assembly::Jp2Create do
  before :each do
    @druid = 'aa222cc3333'
    allow(Dor::Assembly::Item).to receive(:new).and_return(@assembly_item)
    @r = Robots::DorRepo::Assembly::Jp2Create.new(:druid => @druid)
  end

  it "should create jp2 for type=item" do
    Dor::Config.configure.assembly.items_only = true
    setup_assembly_item(@druid, :item)
    expect(@assembly_item).to receive(:is_item?)
    expect(@assembly_item).to receive(:load_content_metadata)
    expect(@assembly_item).to receive(:create_jp2s)
    @r.perform(@assembly_item)
  end

  it "should not create jp2 for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only = true
    setup_assembly_item(@druid, :set)
    expect(@assembly_item).to receive(:is_item?)
    expect(@assembly_item).not_to receive(:load_content_metadata)
    expect(@assembly_item).not_to receive(:create_jp2s)
    @r.perform(@assembly_item)
  end

  it "should create jp2 for type=set if configured that way" do
    Dor::Config.configure.assembly.items_only = false
    setup_assembly_item(@druid, :set)
    expect(@assembly_item).not_to receive(:is_item?)
    expect(@assembly_item).to receive(:load_content_metadata)
    expect(@assembly_item).to receive(:create_jp2s)
    @r.perform(@assembly_item)
  end
end
