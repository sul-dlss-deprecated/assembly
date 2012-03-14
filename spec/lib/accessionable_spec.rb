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
      d    = double 'dor_double'
      d.should_receive(:initialize_workspace ).with conf.root_dir
      d.should_receive(:initiate_apo_workflow).with conf.next_workflow
      @item.stub(:get_dor_object).and_return(d)
      @item.initiate_accessioning
    end

  end

end
