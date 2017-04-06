require 'spec_helper'

describe Dor::Assembly::Accessionable do

  before :each do
    @item              = TestableItem.new
    @item.druid        = DruidTools::Druid.new 'aa111bb2222'
    @item.root_dir     = Dor::Config.assembly.root_dir
  end

  describe '#AccessionableItem' do
    it 'should be able to initialize our testing object' do
      expect(@item).to be_a_kind_of TestableItem
    end
  end

  describe '#initiate_accessioning' do

    it 'should be runnable using stubs for external calls for an item type object' do
      allow(@item).to receive(:object_type).and_return('item')
      FakeWeb.register_uri(:post, "https://localhost/dor/v1/objects/druid:aa111bb2222/initialize_workspace", :body => "ok", :status => ["200"])
      FakeWeb.register_uri(:post, "https://localhost/dor/v1/objects/druid:aa111bb2222/apo_workflows/accessionWF", :body => "ok", :status => ["200"])
      expect(@item).to receive(:initialize_workflow)
      expect(@item).to receive(:initialize_workspace)
      expect(@item.initiate_accessioning).to be_truthy
    end

    it 'should be runnable using stubs for external calls for a collection type object but not initlaize workspace' do
      allow(@item).to receive(:object_type).and_return('collection')
      FakeWeb.register_uri(:post, "https://localhost/dor/v1/objects/druid:aa111bb2222/initialize_workspace", :body => "ok", :status => ["200"])
      FakeWeb.register_uri(:post, "https://localhost/dor/v1/objects/druid:aa111bb2222/apo_workflows/accessionWF", :body => "ok", :status => ["200"])
      expect(@item).to receive(:initialize_workflow)
      expect(@item).to_not receive(:initialize_workspace)
      expect(@item.initiate_accessioning).to be_truthy
    end

  end

end
