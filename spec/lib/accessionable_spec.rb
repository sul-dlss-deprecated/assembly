class AccessionableItem
  include Dor::Assembly::Accessionable
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Accessionable do
  
  before :each do
    root_dir           = Dor::Config.assembly.root_dir
    @item              = AccessionableItem.new
    @item.druid        = Druid.new 'aa111bb2222'
  end

  describe '#AccessionableItem' do
    it 'should be able to initialize our testing object' do
      @item.should be_a_kind_of AccessionableItem
    end
  end

  describe '#initiate_accessioning' do
  
    it 'should be runnable using stubs for external calls' do
      conf = Dor::Config.assembly
      @item.should_receive(:initialize_workspace)
      @item.should_receive(:initialize_apo_workflow)
      RestClient.stub(:post) # don't actually make the RestClient calls, just assume they work
      @item.initiate_accessioning
    end

  end

end
