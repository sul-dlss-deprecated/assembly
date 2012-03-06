class ChecksumableItem
  include Dor::Assembly::Checksumable
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Checksumable do
  
  before :each do
    dummy_xml         = '<contentMetadata><file></file></contentMetadata>'
    @item             = ChecksumableItem.new
    @item.cm          = Nokogiri::XML dummy_xml
    @checksums        = { :md5 => "a123", :sha1 => "567c" }
    @parent_file_node = @item.cm.xpath('//file').first
  end
 
  def cs_nodes
    @item.cm.xpath '//file/checksum'
  end

  it "can be instantiated" do
    @item.should be_kind_of ChecksumableItem
  end
  
  describe '#compute_checksums' do
  
    it 'BLAHHHHHHHHH' do
    end

  end

  describe "#add_checksum_nodes" do
    
    it "should correctly add checksum nodes as children of the parent_node" do
      cs_nodes.size.should == 0
      @item.add_checksum_nodes @parent_file_node, @checksums
      h = Hash[ cs_nodes.map { |n| [ n['type'].to_sym, n.content ] } ]
      h.should == @checksums
    end

  end

  describe "#remove_checksum_nodes" do
    
    it "should remove all checksum child nodes from the parent_node" do
      @item.add_checksum_nodes @parent_file_node, @checksums
      cs_nodes.size.should == @checksums.size
      @item.remove_checksum_nodes @parent_file_node
      cs_nodes.size.should == 0
    end

  end

end
