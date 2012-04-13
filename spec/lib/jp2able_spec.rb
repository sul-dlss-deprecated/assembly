class Jp2ableItem
  include Dor::Assembly::Jp2able
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Jp2able do
  
  before :each do
    basic_setup 'aa111bb2222'
  end

  def basic_setup(dru, root_dir = nil)
    root_dir           = root_dir || Dor::Config.assembly.root_dir
    cm_file_name       = Dor::Config.assembly.cm_file_name
    @item              = Jp2ableItem.new
    @item.druid        = Druid.new dru
    @item.root_dir     = root_dir
    @item.cm_file_name = File.join root_dir, @item.druid.path, cm_file_name
    @dummy_xml         = '<contentMetadata><resource></resource></contentMetadata>'
  end
 
  describe '#Jp2ableItem' do
    it 'should be able to initialize our testing object' do
      @item.should be_a_kind_of Jp2ableItem
    end
  end

  describe '#create_jp2s' do
  
    before(:each) do
      @tmp_root_dir = "tmp/test_input"
      clone_test_input @tmp_root_dir
    end

    it 'should create the expected jp2 files' do
      basic_setup 'aa111bb2222', @tmp_root_dir
      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.path_to_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }

      # Only tifs should exist.
      @item.file_nodes.size.should == 2
      tifs.all?  { |t| File.file? t }.should == true
      jp2s.none? { |j| File.file? j }.should == true

      # Both tifs and jp2s should exist.
      @item.create_jp2s
      @item.file_nodes.size.should == 4
      tifs.all? { |t| File.file? t }.should == true
      jp2s.all? { |j| File.file? j }.should == true
    end

    it 'should persist the expected changes to content metadata XML file' do
      basic_setup 'aa111bb2222', @tmp_root_dir
      @item.load_content_metadata

      # Only 2 tifs should exist before calling method.
      @item.file_nodes.size.should == 2
      @item.create_jp2s

      # Read the XML file and check the file names.
      xml = Nokogiri::XML File.read(@item.cm_file_name)
      file_nodes = xml.xpath "//resource/file"
      file_nodes.map { |fn| fn['id'] }.sort.should == %w(
        image111.jp2 image111.tif
        image112.jp2 image112.tif
      )
    end

  end

  describe '#add_jp2_file_node' do
    
    it 'should add the expected <file> node to XML' do
      exp_xml = <<-END.gsub(/^ {8}/, '')
        <?xml version="1.0"?>
        <contentMetadata>
          <resource>
            <file id="foo.tif"/>
          </resource>
        </contentMetadata>
      END
      exp_xml = noko_doc exp_xml

      @item.cm = noko_doc @dummy_xml
      resource_node = @item.cm.xpath('//resource').first

      @item.add_jp2_file_node resource_node, 'foo.tif'
      @item.cm.should be_equivalent_to exp_xml
    end

  end

end
