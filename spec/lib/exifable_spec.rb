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

      # check that each file node does not start with size, mimetype attributes
      bef_file_nodes=bef.xpath('//file')
      bef_file_nodes.size.should == 3
      bef_file_nodes.each do |file_node|
        file_node.attributes['size'].nil?.should == true
        file_node.attributes['mimetype'].nil?.should == true
      end

      # check that each resource node starts out without a type
      bef_res_nodes=bef.xpath('//resource')
      bef_res_nodes.size.should == 3
      bef_res_nodes.each do |res_node|
        res_node.attributes['type'].nil?.should == true
      end

      # check that each file node now has size, mimetype 
      aft_file_nodes=aft.xpath('//file')
      aft_file_nodes.size.should == 3
      aft_file_nodes[0].attributes['size'].value.should == '63468'
      aft_file_nodes[1].attributes['size'].value.should == '63472'
      aft_file_nodes.each {|file_node| file_node.attributes['mimetype'].value.should == 'image/tiff'}

      # check that each resource node ends up as type=image
      aft_res_nodes=aft.xpath('//resource')
      aft_res_nodes.size.should == 3
      aft_res_nodes.each do |res_node|
        res_node.attributes['type'].value.should == 'image'
      end
            
      # check for imageData nodes being present for each file node
      bef.xpath('//file/imageData').size.should == 0
      aft.xpath('//file/imageData').size.should == 3

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

      # check that the first resource node starts with a type="page" and the second is blank
      bef_res_nodes=bef.xpath('//resource')
      bef_res_nodes.size.should == 3
      bef_res_nodes[0].attributes['type'].value.should == 'page' # first resource type should be set to page
      bef_res_nodes[1].attributes['type'].nil?.should == true # second resource type should not exist
      bef_res_nodes[2].attributes['type'].nil?.should == true # second and third resource type should not exist
            
      # check that each file node does not start with size, mimetype attributes
      bef_file_nodes=bef.xpath('//file')
      bef_file_nodes.size.should == 6
      bef_file_nodes.each do |file_node|
        file_node.attributes['size'].nil?.should == true
        file_node.attributes['mimetype'].nil?.should == true
        # the first file node as the publish/preserve/attributes already set, the others do not
        expected = (file_node == bef_file_nodes.first)? false : true
        file_node.attributes['publish'].nil?.should == expected
        file_node.attributes['preserve'].nil?.should == expected
        file_node.attributes['shelve'].nil?.should == expected
      end

      # check that the file nodes now have the correct size, mimetype 
      aft_file_nodes=aft.xpath('//file')
      aft_file_nodes.size.should == 6
      aft_file_nodes[0].attributes['size'].value.should == '63468'
      aft_file_nodes[0].attributes['mimetype'].value.should == 'image/tiff'
      # the first file node should preserve the existing publish/preserve/shelve attributes set in the incoming content metadata and not overwrite them with the default for tiff
      aft_file_nodes[0].attributes['publish'].value.should == 'yes'
      aft_file_nodes[0].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[0].attributes['shelve'].value.should == 'yes'

      # all other file nodes will have their publish/preserve/shelve attributes set
      aft_file_nodes[1].attributes['size'].value.should == '450604'
      aft_file_nodes[1].attributes['mimetype'].value.should == 'audio/x-wav'
      aft_file_nodes[1].attributes['publish'].value.should == 'no'
      aft_file_nodes[1].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[1].attributes['shelve'].value.should == 'no'

      aft_file_nodes[2].attributes['size'].value.should == '3151'
      aft_file_nodes[2].attributes['mimetype'].value.should == 'application/pdf'
      aft_file_nodes[2].attributes['publish'].value.should == 'yes'
      aft_file_nodes[2].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[2].attributes['shelve'].value.should == 'yes'

      aft_file_nodes[3].attributes['size'].value.should == '3151'
      aft_file_nodes[3].attributes['mimetype'].value.should == 'application/pdf'
      aft_file_nodes[3].attributes['publish'].value.should == 'yes'
      aft_file_nodes[3].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[3].attributes['shelve'].value.should == 'yes'

      aft_file_nodes[4].attributes['size'].value.should == '42212'
      aft_file_nodes[4].attributes['mimetype'].value.should == 'audio/mpeg'
      aft_file_nodes[4].attributes['publish'].value.should == 'yes'
      aft_file_nodes[4].attributes['preserve'].value.should == 'no'
      aft_file_nodes[4].attributes['shelve'].value.should == 'yes'

      aft_file_nodes[5].attributes['size'].value.should == '63468'
      aft_file_nodes[5].attributes['mimetype'].value.should == 'image/tiff'
      aft_file_nodes[5].attributes['publish'].value.should == 'no'
      aft_file_nodes[5].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[5].attributes['shelve'].value.should == 'no'
      
      # check that each resource node end with a type="page" (i.e. was not changed)
      aft_res_nodes=aft.xpath('//resource')
      aft_res_nodes.size.should == 3
      aft_res_nodes[0].attributes['type'].value.should == 'page' # first resource type should be set to page (which is was before)
      aft_res_nodes[1].attributes['type'].value.should == 'file' # second resource type should be set to file (which is the default if it contains no images)
      aft_res_nodes[2].attributes['type'].value.should == 'image' # third resource type should be set to image (which is the default if it contains an images)
      
      # check for imageData nodes being present for each file node that is an image
      bef.xpath('//file/imageData').size.should == 0
      aft.xpath('//file/imageData').size.should == 2

    end

  end

end
