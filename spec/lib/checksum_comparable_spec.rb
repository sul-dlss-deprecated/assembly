class ChecksumComparableItem
  include Dor::Assembly::ChecksumComparable
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::ChecksumComparable do
  
  before :each do
    @item = ChecksumComparableItem.new
  end

  it "!!initialize" do
    @item.should be_a_kind_of ChecksumComparableItem
  end

end
