class ChecksumableItem
  include Dor::Assembly::Checksumable
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Checksumable do
  
  before :each do
    dummy_xml = '<contentMetadata><file></file></contentMetadata>'
    root_dir  = 'spec/test_input'
    dru       = 'aa111bb2222'
    cm_file   = Dor::Config.assembly.content_metadata_file_name

    @item              = ChecksumableItem.new
    @item.druid        = Druid.new dru
    @item.root_dir     = root_dir
    @item.cm           = Nokogiri::XML dummy_xml
    @item.cm_file_name = File.join root_dir, @item.druid.path, cm_file

    @fake_checksum_data = { :md5 => "a123", :sha1 => "567c" }
    @parent_file_node   = @item.cm.xpath('//file').first

    @exp_checksums = {
      "image111.tif" => {
        "md5"  => '7e40beb08d646044529b9138a5f1c796',
        "sha1" => 'ffed9bddf353e7a6445bdec9ae3ab8525a3ee690',
      },
      "image112.tif" => {
        "md5"  => '4e3cd24dd79f3ec91622d9f8e5ab5afa',
        "sha1" => '84e124b7ef4ec38d853c45e7b373b57201e28431',
      },
    }
  end
 
  def all_cs_nodes
    @item.cm.xpath '//file/checksum'
  end

  describe '#compute_checksums' do
  
    before(:each) do
      # Set cm_handle so that the call to compute_checksums does not
      # modify our content_metadata.xml file in spec/test_input.
      @tmpfile = Tempfile.new 'persist_content_metadata_', 'tmp'
      @item.cm_handle = @tmpfile
    end

    it 'should update the content metadata correctly' do
      @item.load_content_metadata
      all_cs_nodes.size.should == 5
      @item.compute_checksums
      all_cs_nodes.size.should == 4

      @item.file_nodes.each do |fnode|
        file_name = fnode['id']
        cnodes    = fnode.xpath './checksum'
        checksums = Hash[ cnodes.map { |cn| [cn['type'], cn.content] } ]
        checksums.should == @exp_checksums[file_name]
      end
    end

  end

  describe "#add_checksum_nodes" do
    
    it "should correctly add checksum nodes as children of the parent_node" do
      all_cs_nodes.size.should == 0
      @item.add_checksum_nodes @parent_file_node, @fake_checksum_data
      h = Hash[ all_cs_nodes.map { |n| [ n['type'].to_sym, n.content ] } ]
      h.should == @fake_checksum_data
    end

  end

  describe "#remove_checksum_nodes" do
    
    it "should remove all checksum child nodes from the parent_node" do
      @item.add_checksum_nodes @parent_file_node, @fake_checksum_data
      all_cs_nodes.size.should == @fake_checksum_data.size
      @item.remove_checksum_nodes @parent_file_node
      all_cs_nodes.size.should == 0
    end

  end

end
