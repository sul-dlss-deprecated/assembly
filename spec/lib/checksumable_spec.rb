class ChecksumableItem
  include Dor::Assembly::Checksumable
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Checksumable do
  
  before :each do
    dru          = 'aa111bb2222'
    dummy_xml    = '<contentMetadata><file></file></contentMetadata>'
    root_dir     = Dor::Config.assembly.root_dir
    cm_file_name = Dor::Config.assembly.cm_file_name

    @item              = ChecksumableItem.new
    @item.druid        = Druid.new dru
    @item.root_dir     = root_dir
    @item.cm           = Nokogiri::XML dummy_xml
    @item.cm_file_name = File.join root_dir, @item.druid.path, cm_file_name

    @fake_checksum_data = { :md5 => "a123", :sha1 => "567c" }
    @parent_file_node   = @item.cm.xpath('//file').first

    @exp_checksums = {
      "image111.tif" => {
        "md5"  => '42616f9e6c1b7e7b7a71b4fa0c5ef794',
        "sha1" => '77795223379bdb0ded2bd5b8a63adc07fb1c3484',
      },
      "image112.tif" => {
        "md5"  => 'ac440802bd590ce0899dafecc5a5ab1b',
        "sha1" => '5c9f6dc2ca4fd3329619b54a2c6f99a08c088444',
      },
    }
  end
 
  def all_cs_nodes
    @item.cm.xpath '//file/checksum'
  end

  describe "#ChecksumableItem" do

    it "should be able to initialize our testing object" do
      @item.should be_a_kind_of ChecksumableItem
    end
    
  end

  describe '#compute_checksums' do
  
    before(:each) do
      # Set cm_handle so that the call to compute_checksums does not
      # modify our testing inputs.
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
