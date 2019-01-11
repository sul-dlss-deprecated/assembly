require 'spec_helper'

RSpec.describe Robots::DorRepo::Assembly::AccessioningInitiate do
  let(:druid) { 'aa222cc3333' }
  let(:robot) { Robots::DorRepo::Assembly::AccessioningInitiate.new(druid: druid) }

  before do
    allow(Dor::Services::Client).to receive(:initialize_workspace)
    allow(Dor::Services::Client).to receive(:initialize_workflow)
  end

  context 'when the type is item' do
    before do
      setup_assembly_item(druid, :item)
    end

    it "initiates accessioning" do
      expect(@assembly_item.is_item?).to be_truthy
      robot.perform(@assembly_item)
      expect(Dor::Services::Client).to have_received(:initialize_workspace)
        .with(object: "druid:aa222cc3333", source: "spec/test_input2/aa/222/cc/3333")
    end
  end

  context 'when the type is set' do
    before do
      setup_assembly_item(druid, :set)
      expect(@assembly_item.is_item?).to be_falsey
    end

    context 'and items_only is the default' do
      it "initiates accessioning, but does not initialize the workspace" do
        robot.perform(@assembly_item)
        expect(Dor::Services::Client).not_to have_received(:initialize_workspace)
        expect(Dor::Services::Client).to have_received(:initialize_workflow)
          .with(object: "druid:aa222cc3333", wf_name: "accessionWF")
      end
    end

    context 'and items_only is set to false' do
      before do
        Dor::Config.configure.assembly.items_only = false
      end
      it "initiates accessioning, but does not initialize the workspace" do
        robot.perform(@assembly_item)
        expect(Dor::Services::Client).not_to have_received(:initialize_workspace)
        expect(Dor::Services::Client).to have_received(:initialize_workflow)
          .with(object: "druid:aa222cc3333", wf_name: "accessionWF")
      end
    end

    context 'and items_only is set to true' do
      before do
        Dor::Config.configure.assembly.items_only = true
      end
      it "initiates accessioning, but does not initialize the workspace" do
        robot.perform(@assembly_item)
        expect(Dor::Services::Client).not_to have_received(:initialize_workspace)
        expect(Dor::Services::Client).to have_received(:initialize_workflow)
          .with(object: "druid:aa222cc3333", wf_name: "accessionWF")
      end
    end
  end
end
