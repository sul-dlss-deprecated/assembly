require 'spec_helper'

describe Robots::DorRepo::Assembly::AccessioningInitiate do

  before :each do
    @druid='aa222cc3333'
    setup_work_item(@druid)
    RestClient.stub(:post) # don't actually make the RestClient calls, just assume they work
    @r = Robots::DorRepo::Assembly::AccessioningInitiate.new(:druid=>@druid)
  end

  it "should initiate accessioning for type=item" do
    setup_assembly_item(@druid,:item)
    @assembly_item.should_receive(:initiate_accessioning)
    @r.perform(@work_item)
  end

  it "should initiate accessioning for type=set" do
    setup_assembly_item(@druid,:set)
    @assembly_item.should_receive(:initiate_accessioning)
    @r.perform(@work_item)
  end

  it "should always initiate accessioning regardless of object type and configuration of items_only=false" do
    Dor::Config.configure.assembly.items_only=false
    setup_assembly_item(@druid,:set)
    @assembly_item.should_receive(:initiate_accessioning)
    @r.perform(@work_item)
  end

  it "should always initiate accessioning regardless of object type and configuration of items_only=true" do
    Dor::Config.configure.assembly.items_only=true
    setup_assembly_item(@druid,:set)
    @assembly_item.should_receive(:initiate_accessioning)
    @r.perform(@work_item)
  end


end
