class ContentMetadataItem
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::ContentMetadata do
   
  def basic_setup(dru, root_dir = nil)
    root_dir           = root_dir || Dor::Config.assembly.root_dir
    cm_file_name       = Dor::Config.assembly.cm_file_name
    @item              = ContentMetadataItem.new
    @item.druid        = DruidTools::Druid.new dru
    @item.root_dir     = root_dir
    @item.cm_file_name = @item.metadata_file cm_file_name
    @dummy_xml         = '<contentMetadata><resource></resource></contentMetadata>'
  end
 
  describe "#load_content_metadata" do

    it "should load a Nokogiri doc in @cm" do
      basic_setup 'aa111bb2222'
      @item.cm = nil
      @item.load_content_metadata
      @item.cm.should be_kind_of Nokogiri::XML::Document
    end

  end

  describe "#persist_content_metadata" do

    before(:each) do
      basic_setup 'aa111bb2222'
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
      basic_setup 'aa111bb2222'
      @item.load_content_metadata
      n = @item.new_node_in_cm 'foo'
      n.to_s.should == '<foo/>'
      n.should be_kind_of Nokogiri::XML::Element
    end

    it "#druid_tree_path should return the expected string" do
      basic_setup 'aa111bb2222'
      @item.root_dir = 'foo/bar'
      @item.druid = DruidTools::Druid.new 'xx999yy8888'
      @item.druid_tree_path.should == 'foo/bar/xx/999/yy/8888/xx999yy8888'
    end

    it "#parent_druid_tree_path should return the expected string" do
      basic_setup 'aa111bb2222'
      @item.root_dir = 'foo/bar'
      @item.druid = DruidTools::Druid.new 'xx999yy8888'
      @item.parent_druid_tree_path.should == 'foo/bar/xx/999/yy/8888'
    end

    it "#path_to_content_file should return expected string" do
      basic_setup 'aa111bb2222'
      @item.root_dir = 'foo/bar'
      @item.druid = DruidTools::Druid.new 'xx999yy8888'
      @item.path_to_content_file('foo.doc').should == 'foo/bar/xx/999/yy/8888/xx999yy8888/content/foo.doc'
    end

    it "#path_to_metadata_file should return expected string" do
      basic_setup 'aa111bb2222'
      @item.root_dir = 'foo/bar'
      @item.druid = DruidTools::Druid.new 'xx999yy8888'
      @item.path_to_metadata_file('foo.xml').should == 'foo/bar/xx/999/yy/8888/xx999yy8888/metadata/foo.xml'
    end

    it "#alt_path_to_file should return expected string" do
      basic_setup 'aa111bb2222'
      @item.root_dir = 'foo/bar'
      @item.druid = DruidTools::Druid.new 'xx999yy8888'
      @item.alt_path_to_file('foo.doc').should == 'foo/bar/xx/999/yy/8888/foo.doc'
    end
    
  end

  describe "Methods returning <file> nodes and filenode-Image tuples" do
    
    it "#file_nodes should return the expected N of Nokogiri elements" do
      basic_setup 'aa111bb2222'
      @item.load_content_metadata
      fns = @item.file_nodes
      fns.size.should == 3
      fns.each { |fn| fn.should be_kind_of Nokogiri::XML::Element }
    end

    it "#file_nodes should return the expected N of Nokogiri elements with new content metadata location" do
      basic_setup 'gg111bb2222'
      @item.load_content_metadata
      fns = @item.file_nodes
      fns.size.should == 3
      fns.each { |fn| fn.should be_kind_of Nokogiri::XML::Element }
    end
    
    it "#fnode_tuples should load the correct N of Node-Image pairs" do
      basic_setup 'aa111bb2222'
      @item.load_content_metadata
      objs = @item.fnode_tuples
      objs.size.should == 3
      objs.each { |file_node, obj|
        file_node.should be_instance_of Nokogiri::XML::Element
        obj.should be_instance_of Assembly::ObjectFile
        obj.object_type.should == :image
      }
    end

    it "#relevant_fnode_tuples should filter out non-approved file types" do
      basic_setup 'cc333dd4444'
      @item.load_content_metadata
      objs = @item.fnode_tuples
      objs.size.should == 2
      objs[0][1].object_type.should == :image # first file is a tiff
      objs[1][1].object_type.should == :text  # second file is a txt
    end

  end

end
