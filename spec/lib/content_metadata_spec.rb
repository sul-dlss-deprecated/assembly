class ContentMetadataItem
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::ContentMetadata do
  
  before(:each) do
    basic_setup 'aa111bb2222'
  end
 
  def basic_setup(dru, root_dir = nil)
    root_dir           = root_dir || Dor::Config.assembly.root_dir
    cmf                = Dor::Config.assembly.cm_file_name
    @item              = ContentMetadataItem.new
    @item.druid        = Druid.new dru
    @item.root_dir     = root_dir
    @item.cm_file_name = File.join root_dir, @item.druid.path, cmf
    @dummy_xml         = '<contentMetadata><resource></resource></contentMetadata>'
  end
 
  describe "#load_content_metadata" do

    it "should load a Nokogiri doc in @cm" do
      @item.cm = nil
      @item.load_content_metadata
      @item.cm.should be_kind_of Nokogiri::XML::Document
    end

  end

  describe "#persist_content_metadata" do

    before(:each) do
      @tmp_dir           = 'tmp'
      @dummy_xml_content = "<xml><foobar /></xml>\n"
      @item.load_content_metadata
      @item.cm.stub(:to_xml).and_return @dummy_xml_content
    end

    it "should write to @cm_handle, if @cm_handle is set" do
      tf = Tempfile.new 'persist_content_metadata_', @tmp_dir
      @item.cm_handle = tf
      @item.persist_content_metadata
      tf.close
      File.read(tf.path).should == @dummy_xml_content
    end


    it "should write to @cm_file_name, if @cm_handle is not set" do
      tf = File.join @tmp_dir, 'out.xml'
      FileUtils.rm_f tf
      File.exists?(tf).should == false
      @item.cm_file_name = tf
      @item.persist_content_metadata
      File.read(tf).should == @dummy_xml_content
    end

  end
  
  describe "Helper methods" do

    it "#new_node_in_cm should return the expected Nokogiri element" do
      @item.load_content_metadata
      n = @item.new_node_in_cm 'foo'
      n.to_s.should == '<foo/>'
      n.should be_kind_of Nokogiri::XML::Element
    end

    it "#druid_tree_path should return the expected string" do
      @item.root_dir = 'foo/bar'
      @item.druid = Druid.new 'xx999yy8888'
      @item.druid_tree_path.should == 'foo/bar/xx/999/yy/8888'
    end

    it "#path_to_file should return expected string" do
      @item.root_dir = 'foo/bar'
      @item.druid = Druid.new 'xx999yy8888'
      @item.path_to_file('foo.doc').should == 'foo/bar/xx/999/yy/8888/foo.doc'
    end

  end

  describe "Methods returning <file> nodes and filenode-Image tuples" do
    
    it "#file_nodes should return the expected N of Nokogiri elements" do
      @item.load_content_metadata
      fns = @item.file_nodes
      fns.size.should == 2
      fns.each { |fn| fn.should be_kind_of Nokogiri::XML::Element }
    end

    it "#fnode_image_tuples should load the correct N of Node-Image pairs" do
      basic_setup 'aa111bb2222'
      @item.load_content_metadata
      imgs = @item.fnode_image_tuples
      imgs.size.should == 2
      imgs.each { |file_node, img|
        file_node.should be_instance_of Nokogiri::XML::Element
        img.should be_instance_of Assembly::Image
      }

      basic_setup 'cc333dd4444'
      @item.load_content_metadata
      imgs = @item.fnode_image_tuples
      imgs.size.should == 2
    end

    it "#relevant_fnode_image_tuples should raise error if passed unsupported image type" do
      basic_setup 'aa111bb2222'
      exp_raise = raise_error /^Invalid image type/
      lambda { @item.relevant_fnode_image_tuples(:foo) }.should exp_raise
    end

    it "#relevant_fnode_image_tuples should filter out non-approved file types" do
      basic_setup 'cc333dd4444'
      @item.load_content_metadata
      imgs = @item.relevant_fnode_image_tuples(:tif)  # Filter out .txt file.
      imgs.size.should == 1
      imgs = @item.relevant_fnode_image_tuples(:jp2)  # There are no jp2 files.
      imgs.size.should == 0
    end

  end

end
