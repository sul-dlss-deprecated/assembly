require 'spec_helper'

describe Robots::DorRepo::Assembly::AccessioningInitiate do
  before :each do
    @druid = 'aa222cc3333'
    allow(RestClient).to receive(:post) # don't actually make the RestClient calls, just assume they work
    allow(Dor::Assembly::Item).to receive(:new).and_return(@assembly_item)
    @r = Robots::DorRepo::Assembly::AccessioningInitiate.new(:druid => @druid)
  end

  it "should initiate accessioning for type=item" do
    setup_assembly_item(@druid, :item)
    expect(@assembly_item.is_item?).to be_truthy
    expect(@assembly_item).to receive(:initialize_workspace)
    expect(@assembly_item).to receive(:initialize_workflow)
    @r.perform(@assembly_item)
  end

  it "should initiate accessioning for type=set but not initalize the workspace" do
    setup_assembly_item(@druid, :set)
    expect(@assembly_item.is_item?).to be_falsey
    expect(@assembly_item).to_not receive(:initialize_workspace)
    expect(@assembly_item).to receive(:initialize_workflow)
    @r.perform(@assembly_item)
  end

  it "should always initiate accessioning regardless of object type and configuration of items_only=false but not initalize the workspace" do
    Dor::Config.configure.assembly.items_only = false
    setup_assembly_item(@druid, :set)
    expect(@assembly_item.is_item?).to be_falsey
    expect(@assembly_item).to_not receive(:initialize_workspace)
    expect(@assembly_item).to receive(:initialize_workflow)
    @r.perform(@assembly_item)
  end

  it "should always initiate accessioning regardless of object type and configuration of items_only=true but not initalize the workspace" do
    Dor::Config.configure.assembly.items_only = true
    setup_assembly_item(@druid, :set)
    expect(@assembly_item.is_item?).to be_falsey
    expect(@assembly_item).to_not receive(:initialize_workspace)
    expect(@assembly_item).to receive(:initialize_workflow)
    @r.perform(@assembly_item)
  end
end
