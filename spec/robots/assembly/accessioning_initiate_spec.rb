require 'spec_helper'

RSpec.describe Robots::DorRepo::Assembly::AccessioningInitiate do
  let(:druid) { 'aa222cc3333' }

  before do
    allow(Dor::Assembly::Item).to receive(:new).and_return(@assembly_item)
    @r = Robots::DorRepo::Assembly::AccessioningInitiate.new(:druid => druid)
  end

  context 'when the type is item' do
    before do
      setup_assembly_item(druid, :item)
      stub_request(:post, "https://localhost/dor/v1/objects/druid:aa222cc3333/initialize_workspace")
        .with(body: { "source" => nil })
        .to_return(status: 200, body: "")
      stub_request(:post, "https://localhost/dor/v1/objects/druid:aa222cc3333/apo_workflows/accessionWF")
        .to_return(status: 200, body: "")
    end

    it "initiates accessioning" do
      expect(@assembly_item.is_item?).to be_truthy
      @r.perform(@assembly_item)
    end
  end

  context 'when the type is set' do
    before do
      setup_assembly_item(druid, :set)
    end

    context 'and items_only is the default' do
      it "initiates accessioning, but does not initialize the workspace" do
        expect(@assembly_item.is_item?).to be_falsey
        expect(@r).to_not receive(:initialize_workspace)
        expect(@r).to receive(:initialize_workflow)
        @r.perform(@assembly_item)
      end
    end

    context 'and items_only is set to false' do
      before do
        Dor::Config.configure.assembly.items_only = false
      end
      it "initiates accessioning, but does not initialize the workspace" do
        expect(@assembly_item.is_item?).to be_falsey
        expect(@r).to_not receive(:initialize_workspace)
        expect(@r).to receive(:initialize_workflow)
        @r.perform(@assembly_item)
      end
    end

    context 'and items_only is set to true' do
      before do
        Dor::Config.configure.assembly.items_only = true
      end
      it "initiates accessioning, but does not initialize the workspace" do
        expect(@assembly_item.is_item?).to be_falsey
        expect(@r).to_not receive(:initialize_workspace)
        expect(@r).to receive(:initialize_workflow)
        @r.perform(@assembly_item)
      end
    end
  end
end
