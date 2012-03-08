class ContentMetadataItem
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::ContentMetadata do
  
  before(:each) do
    cmf                = Dor::Config.assembly.cm_file_name
    root_dir           = Dor::Config.assembly.root_dir
    @item              = ContentMetadataItem.new
    @item.cm_file_name = "#{root_dir}/aa/111/bb/2222/#{cmf}"
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

    it "#file_nodes should return the expected N of Nokogiri elements" do
      @item.load_content_metadata
      fns = @item.file_nodes
      fns.size.should == 2
      fns.each { |fn| fn.should be_kind_of Nokogiri::XML::Element }
    end

  end

end
