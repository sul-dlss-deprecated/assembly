class ChecksumableItem
  include Dor::Assembly::Checksumable
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Checksumable do
  
  before :each do
    @item              = ChecksumableItem.new
    @item.cm_file_name = 'spec/test_input/aa/111/bb/2222/content_metadata.xml'
  end
  
  it "can be instantiated" do
    @item.should be_kind_of ChecksumableItem
  end
  
end