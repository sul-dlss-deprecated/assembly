class ChecksumableItem
  include Dor::Checksumable
end

describe Dor::Checksumable do
  
  before :each do
    @item = ChecksumableItem.new
  end
  
  it "can be instantiated" do
    @item.should be_kind_of ChecksumableItem
  end
  
end
