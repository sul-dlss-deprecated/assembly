class ChecksumableItem
  include Dor::Assembly::Checksumable
end

describe Dor::Assembly::Checksumable do
  
  before :each do
    @item = ChecksumableItem.new
  end
  
  it "can be instantiated" do
    @item.should be_kind_of ChecksumableItem
  end
  
end
