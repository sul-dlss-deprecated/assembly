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
      @item.load_content_metadata
      expect(@item.cm).to be_kind_of Nokogiri::XML::Document
    end
    it "should raise an exception if no contentMetadata file is present" do
      basic_setup 'aa111bb3333'
      expect{@item.load_content_metadata}.to raise_error(StandardError)
    end
  end

  describe "#load_stub_content_metadata" do
    it "should load a Nokogiri doc in @stub_cm" do
      basic_setup 'aa111bb3333'
      @item.load_stub_content_metadata
      expect(@item.stub_cm).to be_kind_of Nokogiri::XML::Document
    end
    it "should raise an exception if no stub contentMetadata file is present" do
      basic_setup 'aa111bb2222'
      expect{@item.load_stub_content_metadata}.to raise_error(StandardError)
    end
  end

  describe "#create_basic_content_metadata" do
    it "should create basic content metadata from a list of files in the new folder style" do
      basic_setup 'aa111bb4444'
      @item.path_to_object
      expect(@item.cm).to be_nil
      expect(@item.folder_style).to eq(:new)
      result = @item.create_basic_content_metadata
      expect(result).to be_equivalent_to <<-END
        <contentMetadata objectId="druid:aa111bb4444" type="file">
          <resource id="aa111bb4444_1" sequence="1" type="file">
            <label>File 1</label>
            <file id="page1.tif"/>
            <file id="page1.txt"/>
          </resource>
          <resource id="aa111bb4444_2" sequence="2" type="file">
            <label>File 2</label>
            <file id="page2.tif"/>
          </resource>
          <resource id="aa111bb4444_3" sequence="3" type="file">
            <label>File 3</label>
            <file id="some_filename.txt"/>
          </resource>
          <resource id="aa111bb4444_4" sequence="4" type="file">
            <label>File 4</label>
            <file id="subfolder/whole_book.pdf"/>
          </resource>
        </contentMetadata>
      END
      expect(@item.cm).to be_kind_of Nokogiri::XML::Document
    end
    it "should create basic content metadata from a list of files in the old folder style" do
      basic_setup 'aa111bb5555'
      @item.path_to_object
      expect(@item.cm).to be_nil
      expect(@item.folder_style).to eq(:old)
      result = @item.create_basic_content_metadata
      expect(result).to be_equivalent_to <<-END
        <contentMetadata objectId="druid:aa111bb5555" type="file">
          <resource id="aa111bb5555_1" sequence="1" type="file">
            <label>File 1</label>
            <file id="test1.txt"/>
          </resource>
          <resource id="aa111bb5555_2" sequence="2" type="file">
            <label>File 2</label>
            <file id="test2.txt"/>
          </resource>
        </contentMetadata>
      END
      expect(@item.cm).to be_kind_of Nokogiri::XML::Document
    end
    it "should raise an exception if content metadata already exists" do
      basic_setup 'aa111bb2222'
      expect{@item.create_basic_content_metadata}.to raise_error(StandardError)
    end
  end

  describe "#convert_stub_content_metadata" do
    it "should create content metadata from stub content metadata" do
      basic_setup 'aa111bb3333'
      expect(@item.cm).to be_nil
      result = @item.convert_stub_content_metadata
      expect(result).to be_equivalent_to <<-END
        <contentMetadata objectId="druid:aa111bb3333" type="book">
          <resource id="aa111bb3333_1" sequence="1" type="page">
            <label>Optional label</label>
            <file id="page1.tif" preserve="yes" publish="no" shelve="no"/>
            <file id="page1.txt" preserve="no" publish="no" shelve="no"/>
          </resource>
          <resource id="aa111bb3333_2" sequence="2" type="page">
            <label>optional page 2 label</label>
            <file id="page2.tif" preserve="yes" publish="no" shelve="no"/>
            <file id="some_filename.txt" preserve="yes" publish="yes" shelve="yes"/>
          </resource>
          <resource id="aa111bb3333_3" sequence="3" type="object">
            <label>Object 1</label>
            <file id="whole_book.pdf" preserve="yes" publish="yes" shelve="yes"/>
          </resource>
        </contentMetadata>
      END
      expect(@item.cm).to be_kind_of Nokogiri::XML::Document
    end
    it "should raise an exception if stub content metadata is missing" do
      basic_setup 'aa111bb2222'
      expect{@item.convert_stub_content_metadata}.to raise_error(StandardError)
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

  describe "#stub_content_metadata_parser" do
    it "should map content metadata types to the gem correctly" do
      basic_setup 'aa111bb3333'
      ['flipbook (r-l)','book','a book (l-r)'].each do |content_type|
        allow(@item).to receive(:stub_object_type).and_return(content_type)
        expect(@item.gem_content_metadata_style).to eq(:simple_book)
      end
      allow(@item).to receive(:stub_object_type).and_return('image')
      expect(@item.gem_content_metadata_style).to eq(:simple_image)
      allow(@item).to receive(:stub_object_type).and_return('maps')
      expect(@item.gem_content_metadata_style).to eq(:map)
      %w(file bogus).each do |content_type|
        allow(@item).to receive(:stub_object_type).and_return(content_type)
        expect(@item.gem_content_metadata_style).to eq(:file)
      end
    end
    it "should parse a stub content metadata file" do
      basic_setup 'aa111bb3333'
      @item.load_stub_content_metadata
      expect(@item.stub_object_type).to eq('book')
      expect(@item.gem_content_metadata_style).to eq(:simple_book)
      resources = @item.resources
      expect(resources.size).to eq(3)
      expected_labels = ['Optional label', 'optional page 2 label', '']
      resources.each_with_index { |r,i| expect(@item.resource_label(r)).to eq(expected_labels[i]) }
      resource_files1 = @item.resource_files(resources[0])
      resource_files2 = @item.resource_files(resources[1])
      resource_files3 = @item.resource_files(resources[2])
      expect(resource_files1.size).to eq(2)
      expect(resource_files2.size).to eq(2)
      expect(resource_files3.size).to eq(1)
      expected_filenames = ['page1.tif', 'page1.txt']
      resource_files1.each_with_index { |rf,i| expect(@item.filename(rf)).to eq(expected_filenames[i]) }
      expected_filenames = ['page2.tif', 'some_filename.txt']
      resource_files2.each_with_index { |rf,i| expect(@item.filename(rf)).to eq(expected_filenames[i]) }
      expected_filenames = ['whole_book.pdf']
      resource_files3.each_with_index { |rf,i| expect(@item.filename(rf)).to eq(expected_filenames[i]) }
      expected_attributes = [nil, {preserve: 'no', publish: 'no', shelve: 'no'}]
      resource_files1.each_with_index { |rf,i| expect(@item.file_attributes(rf)).to eq(expected_attributes[i]) }
      expected_attributes = [nil, nil]
      resource_files2.each_with_index { |rf,i| expect(@item.file_attributes(rf)).to eq(expected_attributes[i]) }
      expected_attributes = [nil]
      resource_files3.each_with_index { |rf,i| expect(@item.file_attributes(rf)).to eq(expected_attributes[i]) }
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
      expect(@item.folder_style).to be nil
    end

    it "#path_to_object should return the expected string when the new druid folder is found" do
      @item.root_dir = TMP_ROOT_DIR
      @item.druid = DruidTools::Druid.new 'xx999yy8888', @item.root_dir
      FileUtils.mkdir_p @item.druid.path
      expect(@item.path_to_object).to eq('tmp/test_input/xx/999/yy/8888/xx999yy8888')
      expect(@item.folder_style).to eq(:new)
      FileUtils.rm_rf @item.druid.path
    end

    it "#path_to_object should return the expected string when the new druid folder is not found, but the older druid style folder is found" do
      @item.root_dir = TMP_ROOT_DIR
      @item.druid = DruidTools::Druid.new 'xx999yy8888', @item.root_dir
      path = @item.old_druid_tree_path(@item.root_dir)
      FileUtils.mkdir_p path
      expect(@item.path_to_object).to eq('tmp/test_input/xx/999/yy/8888')
      expect(@item.folder_style).to eq(:old)
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
