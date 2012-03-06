class ContentMetadataItem
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::ContentMetadata do
  
  before(:each) do
    @item              = ContentMetadataItem.new
    @item.cm_file_name = 'spec/test_input/aa/111/bb/2222/content_metadata.xml'
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
  
  describe "#new_node_in_cm" do

    before(:each) do
      @item.load_content_metadata
    end

    it "should return the expected Nokogiri node" do
      n = @item.new_node_in_cm 'foo'
      n.to_s.should == '<foo/>'
      n.should be_kind_of Nokogiri::XML::Element
    end

  end

end
