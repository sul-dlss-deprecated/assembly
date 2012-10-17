class ChecksumableItem
  include Dor::Assembly::Checksumable
  include Dor::Assembly::ContentMetadata
  include Dor::Assembly::Findable  
end

describe Dor::Assembly::Checksumable do
  
  def basic_setup(dru, root_dir = nil)
    root_dir           = root_dir || Dor::Config.assembly.root_dir
    dummy_xml    = '<contentMetadata><file></file></contentMetadata>'
    root_dir     = Dor::Config.assembly.root_dir
    cm_file_name = Dor::Config.assembly.cm_file_name

    @item              = ChecksumableItem.new
    @item.druid        = DruidTools::Druid.new dru
    @item.root_dir     = root_dir
    @item.cm           = Nokogiri::XML dummy_xml
    @item.cm_file_name = @item.metadata_file cm_file_name

    @fake_checksum_data = { :md5 => "a123", :sha1 => "567c" }
    @parent_file_node   = @item.cm.xpath('//file').first
  end
     
  def all_cs_nodes
    @item.cm.xpath '//file/checksum'
  end

  def all_file_nodes
    @item.cm.xpath '//file'
  end
  
  def setup_tmp_handle
     @tmpfile = Tempfile.new 'persist_content_metadata_', 'tmp'
     @item.cm_handle = @tmpfile
  end
  
  describe "#ChecksumableItem" do

    it "should be able to initialize our testing object" do
      basic_setup('aa111bb2222')
      @item.should be_a_kind_of ChecksumableItem
    end
    
  end

  describe '#compute_checksums' do
    
    it 'should update the content metadata correctly, adding checksums where they are missing, and leaving any existing checksums intact' do
      
      basic_setup('aa111bb2222')
      setup_tmp_handle
      
      @item.load_content_metadata
      all_cs_nodes.size.should == 5
      @item.compute_checksums
      all_cs_nodes.size.should == 8

      @exp_checksums = {
        "image111.tif" => {
          "md5"  => '42616f9e6c1b7e7b7a71b4fa0c5ef794',
          "sha1" => '77795223379bdb0ded2bd5b8a63adc07fb1c3484',
        },
        "image112.tif" => {
          "md5"  => 'ac440802bd590ce0899dafecc5a5ab1b',
          "sha1" => '5c9f6dc2ca4fd3329619b54a2c6f99a08c088444',
          "foo"=>"FOO", "bar"=>"BAR", 
        },
        "sub/image113.tif" => {
          "md5"  => 'ac440802bd590ce0899dafecc5a5ab1b',
          "sha1" => '5c9f6dc2ca4fd3329619b54a2c6f99a08c088444',
        },
      }

      all_file_nodes.each do |fnode|
        file_name = fnode['id']
        cnodes    = fnode.xpath './checksum'
        checksums = Hash[ cnodes.map { |cn| [cn['type'], cn.content] } ]
        checksums.should == @exp_checksums[file_name]
      end
    end

    it 'should update the content metadata correctly in the new location, adding checksums where they are missing, and leaving any existing checksums intact' do
      
      basic_setup('gg111bb2222')
      setup_tmp_handle
      
      @item.load_content_metadata
      all_cs_nodes.size.should == 4
      @item.compute_checksums
      all_cs_nodes.size.should == 7

      @exp_checksums = {
        "image111.tif" => {
          "md5"  => '42616f9e6c1b7e7b7a71b4fa0c5ef794',
          "sha1" => '77795223379bdb0ded2bd5b8a63adc07fb1c3484',
        },
        "image112.tif" => {
          "md5"  => 'ac440802bd590ce0899dafecc5a5ab1b',
          "sha1" => '5c9f6dc2ca4fd3329619b54a2c6f99a08c088444',
          "bar"=>"BAR", 
        },
        "sub/image113.tif" => {
          "md5"  => 'ac440802bd590ce0899dafecc5a5ab1b',
          "sha1" => '5c9f6dc2ca4fd3329619b54a2c6f99a08c088444',
        },
      }

      all_file_nodes.each do |fnode|
        file_name = fnode['id']
        cnodes    = fnode.xpath './checksum'
        checksums = Hash[ cnodes.map { |cn| [cn['type'], cn.content] } ]
        checksums.should == @exp_checksums[file_name]
      end
    end
    
    it 'should not fail when an existing md5 checksum matches but is CAP CASE' do
      
      basic_setup('aa111bb2222')
      setup_tmp_handle    
      
      @item.load_content_metadata
      
      all_file_nodes[0].xpath('checksum[@type="md5"]')[0].content='42616f9E6C1B7E7B7A71B4FA0C5Ef794'  # change the md5 hash in the first file node to be all caps
      all_cs_nodes.size.should == 5
      
      # now check that it was re-computed and still succeeds
      lambda { @item.compute_checksums }.should_not raise_error

      # this was the first file node it got to, so no new checksums were added
      all_cs_nodes.size.should == 8
      
    end

    it 'should fail when an existing md5 checksum does not match' do
      
      basic_setup('aa111bb2222')
      setup_tmp_handle
      
      @item.load_content_metadata
      
      all_file_nodes[0].xpath('checksum[@type="md5"]')[0].content='flimflam'  # change the md5 hash in the first file node
      all_cs_nodes.size.should == 5
      
      # now check that it was re-computed and failed
      exp_msg = /^Checksums disagree: type="md5", file="image111.tif"./
      lambda { @item.compute_checksums }.should raise_error RuntimeError, exp_msg

      # this was the first file node it got to, so no new checksums were added before it failed
      all_cs_nodes.size.should == 5
      
    end

    it 'should fail when an existing md5 checksum does not match with content metadata in new location' do
      
      basic_setup('gg111bb2222')
      setup_tmp_handle
      
      @item.load_content_metadata
      
      all_file_nodes[0].xpath('checksum[@type="md5"]')[0].content='flimflam'  # change the md5 hash in the first file node
      all_cs_nodes.size.should == 4
      
      # now check that it was re-computed and failed
      exp_msg = /^Checksums disagree: type="md5", file="image111.tif"./
      lambda { @item.compute_checksums }.should raise_error RuntimeError, exp_msg

      # this was the first file node it got to, so no new checksums were added before it failed
      all_cs_nodes.size.should == 4
      
    end
        
    it 'should fail when an existing sha1 checksum does not match, but continue to add checksums to other missing nodes before that' do
      
      basic_setup('aa111bb2222')
      setup_tmp_handle
      
      @item.load_content_metadata
      all_file_nodes[1].xpath('checksum[@type="sha1"]')[0].content='crapola'  # change the md5 hash in the first file node
      
      all_cs_nodes.size.should == 5
      
      # now check that it was re-computed and failed
      exp_msg = /^Checksums disagree: type="sha1", file="image112.tif"./
      lambda { @item.compute_checksums }.should raise_error RuntimeError, exp_msg

      # at this point it added a sha1 checksum to the first file node already
      all_cs_nodes.size.should == 6
      
    end

    it 'should fail when any existing md5 checksum does not match (even when there are multiple for a given file node)' do
      
      basic_setup('aa111bb2222')
      setup_tmp_handle
      
      @item.load_content_metadata

      # start out with 5 checksum nodes
      all_cs_nodes.size.should == 5

      # keep the correct first md5 checksum for the first file, but add a bogous one too
      @item.add_checksum_node @item.cm.xpath('//file').first, 'md5','junk'
      
      # we now have six checksum nodes
      all_cs_nodes.size.should == 6
      
      # now check that it was re-computed and failed, even though the first still matches
      exp_msg = /^Checksums disagree: type="md5", file="image111.tif"./
      lambda { @item.compute_checksums }.should raise_error RuntimeError, exp_msg

      # this was the first file node it got to, so no new checksums were added before it failed
      all_cs_nodes.size.should == 6
      
    end

    
  end

  describe "#add_checksum_nodes" do
    
    it "should correctly add checksum nodes as children of the parent_node" do
      basic_setup('aa111bb2222')
      
      all_cs_nodes.size.should == 0
      @item.add_checksum_node @parent_file_node, 'md5',@fake_checksum_data[:md5]
      @item.add_checksum_node @parent_file_node, 'sha1',@fake_checksum_data[:sha1]
      all_cs_nodes.size.should == 2
      h = Hash[ all_cs_nodes.map { |n| [ n['type'].to_sym, n.content ] } ]
      h.should == @fake_checksum_data
    end

  end

end
