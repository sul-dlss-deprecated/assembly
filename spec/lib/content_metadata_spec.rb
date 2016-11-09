require 'spec_helper'

class ContentMetadataItem
  include Dor::Assembly::ContentMetadata
  include Dor::Assembly::Findable
end

describe Dor::Assembly::ContentMetadata do

  def basic_setup(dru, root_dir = nil)
    root_dir           = root_dir || Dor::Config.assembly.root_dir
    @item              = ContentMetadataItem.new
    @item.druid        = DruidTools::Druid.new dru
    @item.root_dir     = root_dir
    @dummy_xml         = '<contentMetadata><resource></resource></contentMetadata>'
  end

  describe "#load_content_metadata" do
    it "should load a Nokogiri doc in @cm" do
      basic_setup 'aa111bb2222'
      @item.cm = nil
      @item.load_content_metadata
      expect(@item.cm).to be_kind_of Nokogiri::XML::Document
    end
  end

  describe "#exists methods" do
    it "should indicate if contentMetadata exists" do
      basic_setup 'aa111bb2222'
      expect(@item.content_metadata_exists?).to be_truthy
    end
    it "should indicate if contentMetadata exists" do
      basic_setup 'aa111bb3333'
      expect(@item.content_metadata_exists?).to be_falsey
    end
    it "should indicate if stub contentMetadata exists" do
      basic_setup 'aa111bb2222'
      expect(@item.stub_content_metadata_exists?).to be_falsey
    end
    it "should indicate if contentMetadata exists" do
      basic_setup 'aa111bb3333'
      expect(@item.stub_content_metadata_exists?).to be_truthy
    end
  end
  
  describe "#persist_content_metadata" do

    before :each do
      basic_setup 'aa111bb2222'
      @tmp_dir           = 'tmp'
      @dummy_xml_content = "<xml><foobar /></xml>\n"
      @item.load_content_metadata
      allow(@item.cm).to receive(:to_xml).and_return @dummy_xml_content
    end

    it "should write to @cm_handle, if @cm_handle is set" do
      tf = Tempfile.new 'persist_content_metadata_', @tmp_dir
      @item.cm_handle = tf
      @item.persist_content_metadata
      tf.close
      expect(File.read(tf.path)).to eq(@dummy_xml_content)
    end

    it "should write to @cm_file_name, if @cm_handle is not set" do
      tf = File.join @tmp_dir, 'out.xml'
      FileUtils.rm_f tf
      expect(File.exists?(tf)).to eq(false)
      @item.cm_file_name = tf
      @item.persist_content_metadata
      expect(File.read(tf)).to eq(@dummy_xml_content)
    end

  end

  describe "Helper methods" do
    before :each do
      basic_setup 'aa111bb2222'
    end

    it "#new_node_in_cm should return the expected Nokogiri element" do
      @item.load_content_metadata
      n = @item.new_node_in_cm 'foo'
      expect(n.to_s).to eq('<foo/>')
      expect(n).to be_kind_of Nokogiri::XML::Element
    end

    it "#path_to_object should return nil when no content folder is not found" do
      @item.root_dir = 'foo/bar'
      @item.druid = DruidTools::Druid.new 'xx999yy8888'
      expect(@item.path_to_object).to be nil
    end

    it "#path_to_object should return the expected string when the new druid folder is found" do
      @item.root_dir = TMP_ROOT_DIR
      @item.druid = DruidTools::Druid.new 'xx999yy8888', @item.root_dir
      FileUtils.mkdir_p @item.druid.path
      expect(@item.path_to_object).to eq('tmp/test_input/xx/999/yy/8888/xx999yy8888')
      FileUtils.rm_rf @item.druid.path
    end

    it "#path_to_object should return the expected string when the new druid folder is not found, but the older druid style folder is found" do
      @item.root_dir = TMP_ROOT_DIR
      @item.druid = DruidTools::Druid.new 'xx999yy8888', @item.root_dir
      path = @item.old_druid_tree_path(@item.root_dir)
      FileUtils.mkdir_p path
      expect(@item.path_to_object).to eq('tmp/test_input/xx/999/yy/8888')
      FileUtils.rm_rf path
    end
  end

  describe "Methods returning <file> nodes and filenode-Image tuples" do

    it "#file_nodes should return the expected N of Nokogiri elements" do
      basic_setup 'aa111bb2222'
      @item.load_content_metadata
      fns = @item.file_nodes
      expect(fns.size).to eq(3)
      fns.each { |fn| expect(fn).to be_kind_of Nokogiri::XML::Element }
    end

    it "#file_nodes should return the expected N of Nokogiri elements with new content metadata location" do
      basic_setup 'gg111bb2222'
      @item.load_content_metadata
      fns = @item.file_nodes
      expect(fns.size).to eq(3)
      fns.each { |fn| expect(fn).to be_kind_of Nokogiri::XML::Element }
    end

    it "#fnode_tuples should load the correct N of Node-Image pairs" do
      basic_setup 'aa111bb2222'
      @item.load_content_metadata
      objs = @item.fnode_tuples
      expect(objs.size).to eq(3)
      objs.each { |file_node, obj|
        expect(file_node).to be_instance_of Nokogiri::XML::Element
        expect(obj).to be_instance_of Assembly::ObjectFile
        expect(obj.object_type).to eq(:image)
      }
    end

    it "#relevant_fnode_tuples should filter out non-approved file types" do
      basic_setup 'cc333dd4444'
      @item.load_content_metadata
      objs = @item.fnode_tuples
      expect(objs.size).to eq(2)
      expect(objs[0][1].object_type).to eq(:image) # first file is a tiff
      expect(objs[1][1].object_type).to eq(:text)  # second file is a txt
    end

  end

end
