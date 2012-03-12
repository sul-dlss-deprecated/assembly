class Jp2ableItem
  include Dor::Assembly::Jp2able
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Jp2able do
  
  before :each do

    # dru          = 'aa111bb2222'
    # dummy_xml    = '<contentMetadata><file></file></contentMetadata>'
    # root_dir     = Dor::Config.assembly.root_dir
    # cm_file_name = Dor::Config.assembly.cm_file_name

    @item              = Jp2ableItem.new
    # @item.druid        = Druid.new dru
    # @item.root_dir     = root_dir
    # @item.cm           = Nokogiri::XML dummy_xml
    # @item.cm_file_name = File.join root_dir, @item.druid.path, cm_file_name

    # @fake_checksum_data = { :md5 => "a123", :sha1 => "567c" }
    # @parent_file_node   = @item.cm.xpath('//file').first

    # @exp_checksums = {
    #   "image111.tif" => {
    #     "md5"  => '7e40beb08d646044529b9138a5f1c796',
    #     "sha1" => 'ffed9bddf353e7a6445bdec9ae3ab8525a3ee690',
    #   },
    #   "image112.tif" => {
    #     "md5"  => '4e3cd24dd79f3ec91622d9f8e5ab5afa',
    #     "sha1" => '84e124b7ef4ec38d853c45e7b373b57201e28431',
    #   },
    # }
  end
 
  describe '#Jp2ableItem' do

    it 'should be able to initialize our testing object' do
      @item.should be_a_kind_of Jp2ableItem
    end
    
  end

  describe '#create_jp2s' do
  
    before(:each) do
      # Set cm_handle so that the call to create_jp2s does not
      # modify our testing inputs.
      @tmpfile = Tempfile.new 'persist_content_metadata_', 'tmp'
      @item.cm_handle = @tmpfile
    end

    it 'should ...' do
      # @item.load_content_metadata
      # all_cs_nodes.size.should == 5
      # @item.compute_checksums
      # all_cs_nodes.size.should == 4

      # @item.file_nodes.each do |fnode|
      #   file_name = fnode['id']
      #   cnodes    = fnode.xpath './checksum'
      #   checksums = Hash[ cnodes.map { |cn| [cn['type'], cn.content] } ]
      #   checksums.should == @exp_checksums[file_name]
      # end
    end

  end

  describe '#add_jp2_file_node' do
    
    it 'should ...' do
      # all_cs_nodes.size.should == 0
      # @item.add_checksum_nodes @parent_file_node, @fake_checksum_data
      # h = Hash[ all_cs_nodes.map { |n| [ n['type'].to_sym, n.content ] } ]
      # h.should == @fake_checksum_data
    end

  end

end
