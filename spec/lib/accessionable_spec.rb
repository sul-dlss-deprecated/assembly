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
      @item.should be_a_kind_of AccessionableItem
    end
  end

  describe '#initiate_accessioning' do
  
    it 'should be runnable using stubs for external calls for an item type object' do
      @item.stub(:object_type).and_return('item')
      @item.should_receive(:initialize_workspace)
      @item.should_receive(:initialize_apo_workflow)
      RestClient.stub(:post) # don't actually make the RestClient calls, just assume they work
      @item.initiate_accessioning
    end
  
    it 'should be runnable using stubs for external calls for a collection type object' do
      @item.stub(:object_type).and_return('collection')
      @item.should_receive(:initialize_workspace)
      @item.should_receive(:initialize_apo_workflow)
      RestClient.stub(:post) # don't actually make the RestClient calls, just assume they work
      @item.initiate_accessioning
    end  
    
  end

end
