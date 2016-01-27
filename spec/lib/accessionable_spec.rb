require 'spec_helper'

class AccessionableItem
  include Dor::Assembly::Accessionable
  include Dor::Assembly::ContentMetadata
  include Dor::Assembly::Findable
end

describe Dor::Assembly::Accessionable do

  before :each do
    @item              = AccessionableItem.new
    @item.druid        = DruidTools::Druid.new 'aa111bb2222'
    @item.root_dir     = Dor::Config.assembly.root_dir
  end

  describe '#AccessionableItem' do
    it 'should be able to initialize our testing object' do
      expect(@item).to be_a_kind_of AccessionableItem
    end
  end

  describe '#initiate_accessioning' do

    it 'should be runnable using stubs for external calls for an item type object' do
      allow(@item).to receive(:object_type).and_return('item')
      expect(@item).to receive(:initialize_workspace)
      expect(@item).to receive(:initialize_apo_workflow)
      allow(RestClient).to receive(:post) # don't actually make the RestClient calls, just assume they work
      @item.initiate_accessioning
    end

    it 'should be runnable using stubs for external calls for a collection type object' do
      allow(@item).to receive(:object_type).and_return('collection')
      expect(@item).to receive(:initialize_workspace)
      expect(@item).to receive(:initialize_apo_workflow)
      allow(RestClient).to receive(:post) # don't actually make the RestClient calls, just assume they work
      @item.initiate_accessioning
    end

  end

end
