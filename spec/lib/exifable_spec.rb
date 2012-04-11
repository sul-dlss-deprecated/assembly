class ExifableItem
  include Dor::Assembly::Exifable
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Exifable do
  
  before :each do
    basic_setup 'aa111bb2222'
  end

  def basic_setup(dru, root_dir = nil)
    root_dir           = root_dir || Dor::Config.assembly.root_dir
    cm_file_name       = Dor::Config.assembly.cm_file_name
    @item              = ExifableItem.new
    @item.druid        = Druid.new dru
    @item.root_dir     = root_dir
    @item.cm_file_name = File.join root_dir, @item.druid.path, cm_file_name
    @dummy_xml         = '<contentMetadata><resource></resource></contentMetadata>'
  end

  describe '#ExifableItem' do
    it 'should be able to initialize our testing object' do
      @item.should be_a_kind_of ExifableItem
    end
  end

  describe 'Simple XML methods' do
  
    it '#set_node_type_as_image should add type="image" attributes correctly' do
      @item.cm = noko_doc @dummy_xml
      %w(contentMetadata resource).each do |tag|
          node = @item.cm.xpath("//#{tag}").first
          @item.set_node_type node,'image'
      end
      exp = Nokogiri::XML( '<contentMetadata type="image"><resource type="image">' + 
                           '</resource></contentMetadata>')
      @item.cm.should be_equivalent_to exp
    end

    it '#image_data_xml should return the expect XML text' do
      exif = double 'image_width' => 55, 'image_height' => 66
      @item.image_data_xml(exif).should == '<imageData width="55" height="66"/>'
    end

  end

  describe '#collect_exif_info' do
  
    before(:each) do
      @tmp_root_dir = "tmp/test_input"
      clone_test_input @tmp_root_dir
    end

    it 'should persist the expected changes to content metadata XML file' do
      basic_setup 'aa111bb2222', @tmp_root_dir

      # Content metadata before.
      @item.load_content_metadata
      bef = noko_doc @item.cm.to_xml

      # Content metadata after (as read from the modified file).
      @item.collect_exif_info
      aft = Nokogiri::XML File.read(@item.cm_file_name)

      # check that the contentmetadata resource type is image after
      bef.root['type'].should == nil
      aft.root['type'].should == 'image'

      # check that each file node does not start with size, mimetype and format attributes
      bef_file_nodes=bef.xpath('//file')
      bef_file_nodes.size.should == 2
      bef_file_nodes.each do |file_node|
        file_node.attributes['size'].nil?.should == true
        file_node.attributes['mimeType'].nil?.should == true
        file_node.attributes['format'].nil?.should == true
      end

      # check that each resource node starts out without a type
      bef_res_nodes=bef.xpath('//resource')
      bef_res_nodes.size.should == 2
      bef_res_nodes.each do |res_node|
        res_node.attributes['type'].nil?.should == true
      end

      # check that each file node now has size, mimetype and format
      aft_file_nodes=aft.xpath('//file')
      aft_file_nodes.size.should == 2
      aft_file_nodes[0].attributes['size'].value.should == '63468'
      aft_file_nodes[1].attributes['size'].value.should == '63472'
      aft_file_nodes.each {|file_node| file_node.attributes['mimeType'].value.should == 'image/tiff' && file_node.attributes['format'].value.should == 'TIFF'}

      # check that each resource node ends up as type=image
      aft_res_nodes=aft.xpath('//resource')
      aft_res_nodes.size.should == 2
      aft_res_nodes.each do |res_node|
        res_node.attributes['type'].value.should == 'image'
      end
            
      # check for imageData nodes being present for each file node
      bef.xpath('//file/imageData').size.should == 0
      aft.xpath('//file/imageData').size.should == 2

    end

    it 'should not overwrite existing contentmetadata type and resource types if they exist in incoming content metadata XML file' do
      basic_setup 'ff222cc3333', @tmp_root_dir

      # Content metadata before.
      @item.load_content_metadata
      bef = noko_doc @item.cm.to_xml
      
      # Content metadata after (as read from the modified file).
      @item.collect_exif_info
      aft = Nokogiri::XML File.read(@item.cm_file_name)

      # check that the content metadata type is preserved as book and not switched to image
      bef.root['type'].should == 'book'
      aft.root['type'].should == 'book'

      # check that each resource node starts with a type="page"
      bef_res_nodes=bef.xpath('//resource')
      bef_res_nodes.size.should == 2
      bef_res_nodes.each do |res_node|
        res_node.attributes['type'].value.should == 'page'
      end
            
      # check that each file node does not start with size, mimetype and format attributes
      bef_file_nodes=bef.xpath('//file')
      bef_file_nodes.size.should == 5
      bef_file_nodes.each do |file_node|
        file_node.attributes['size'].nil?.should == true
        file_node.attributes['mimeType'].nil?.should == true
        file_node.attributes['format'].nil?.should == true
      end

      # check that each file node now has size, mimetype and format
      aft_file_nodes=aft.xpath('//file')
      aft_file_nodes.size.should == 5
      aft_file_nodes[0].attributes['size'].value.should == '63468'
      aft_file_nodes[1].attributes['size'].value.should == '63472'
      aft_file_nodes.each {|file_node| file_node.attributes['mimeType'].value.should == 'image/tiff' && file_node.attributes['format'].value.should == 'TIFF'}

      # check that each resource node starts with a type="page"
      aft_res_nodes=aft.xpath('//resource')
      aft_res_nodes.size.should == 2
      aft_res_nodes.each do |res_node|
        res_node.attributes['type'].value.should == 'page'
      end
      
      # check for imageData nodes being present for each file node
      bef.xpath('//file/imageData').size.should == 0
      aft.xpath('//file/imageData').size.should == 2

    end

  end

end
