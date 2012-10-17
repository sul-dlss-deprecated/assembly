class ExifableItem
  include Dor::Assembly::Exifable
  include Dor::Assembly::ContentMetadata
  include Dor::Assembly::Findable
end

describe Dor::Assembly::Exifable do
  
  before :each do
    basic_setup 'aa111bb2222'
  end

  def basic_setup(dru, root_dir = nil)
    root_dir           = root_dir || Dor::Config.assembly.root_dir
    cm_file_name       = Dor::Config.assembly.cm_file_name
    @item              = ExifableItem.new
    @item.druid        = DruidTools::Druid.new dru
    @item.root_dir     = root_dir
    @item.cm_file_name = @item.metadata_file cm_file_name
    @dummy_xml         = '<contentMetadata><resource></resource></contentMetadata>'
  end

  def run_persist_xml_test
  
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

    # check that each resource node starts out with type=image
    bef_res_nodes=bef.xpath('//resource')
    bef_res_nodes.size.should == 3
    bef_res_nodes.each do |res_node|
      res_node.attributes['type'].value.should == 'image'
    end

    # check that each file node now has size, mimetype 
    aft_file_nodes=aft.xpath('//file')
    aft_file_nodes.size.should == 3
    aft_file_nodes[0].attributes['size'].value.should == '63468'
    aft_file_nodes[1].attributes['size'].value.should == '63472'
    aft_file_nodes.each {|file_node| file_node.attributes['mimetype'].value.should == 'image/tiff'}

    # check that each resource node is still type=image
    aft_res_nodes=aft.xpath('//resource')
    aft_res_nodes.size.should == 3
    aft_res_nodes.each do |res_node|
      res_node.attributes['type'].value.should == 'image'
    end
          
    # check for imageData nodes being present for each file node
    bef.xpath('//file/imageData').size.should == 0
    aft.xpath('//file/imageData').size.should == 3
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
      clone_test_input TMP_ROOT_DIR
    end

    it 'should persist the expected changes to content metadata XML file' do
      basic_setup 'aa111bb2222', TMP_ROOT_DIR
      run_persist_xml_test
    end

    it 'should persist the expected changes to content metadata XML file in the new locatin' do
      basic_setup 'gg111bb2222', TMP_ROOT_DIR
      run_persist_xml_test
    end

    it 'should not overwrite existing mimetypes and filesizes in file nodes if they exist in incoming content metadata XML file' do
      basic_setup 'cc333dd4444', TMP_ROOT_DIR

      # Content metadata before.
      @item.load_content_metadata
      
      bef = noko_doc @item.cm.to_xml
      
      # Content metadata after (as read from the modified file).
      @item.collect_exif_info
      aft = Nokogiri::XML File.read(@item.cm_file_name)

      # check that the content metadata type is image (default for only images)
      bef.root['type'].nil?.should == true
      aft.root['type'].should == 'image'

      # check that the first resource node starts with a type="page" and the second is blank
      bef_res_nodes=bef.xpath('//resource')
      bef_res_nodes.size.should == 1
      bef_res_nodes[0].attributes['type'].nil?.should == true  # first resource type should not exist
            
      # check that each file node starts with size, mimetype attributes
      bef_file_nodes=bef.xpath('//file')
      bef_file_nodes.size.should == 2
      bef_file_nodes.each do |file_node|
        file_node.attributes['size'].nil?.should == false
        file_node.attributes['mimetype'].nil?.should == false
      end

      # check that the file nodes still have bogus size, mimetype 
      aft_file_nodes=aft.xpath('//file')
      aft_file_nodes.size.should == 2
      aft_file_nodes[0].attributes['size'].value.should == '100'
      aft_file_nodes[0].attributes['mimetype'].value.should == 'crappy/mimetype'

      # all other file nodes will have their publish/preserve/shelve attributes set
      aft_file_nodes[1].attributes['size'].value.should == '500'
      aft_file_nodes[1].attributes['mimetype'].value.should == 'crappy/again'
            
      # check that each resource node end with a type="file" (i.e. was not changed)
      aft_res_nodes=aft.xpath('//resource')
      aft_res_nodes.size.should == 1
      aft_res_nodes[0].attributes['type'].value.should == 'file' # first resource type should be set to file (default when not all files are images)
      
      # check for imageData nodes being present for each file node that is an image
      bef.xpath('//file/imageData').size.should == 0
      aft.xpath('//file/imageData').size.should == 1

    end
    
    it 'should not overwrite existing contentmetadata type and resource types if they exist in incoming content metadata XML file' do
      basic_setup 'ff222cc3333', TMP_ROOT_DIR

      # Content metadata before.
      @item.load_content_metadata
      
      bef = noko_doc @item.cm.to_xml
      
      # Content metadata after (as read from the modified file).
      @item.collect_exif_info
      aft = Nokogiri::XML File.read(@item.cm_file_name)

      # check that the content metadata type is preserved as file and not switched to image
      bef.root['type'].should == 'file'
      aft.root['type'].should == 'file'

      # check that the first resource node starts with a type="page" and the second is blank
      bef_res_nodes=bef.xpath('//resource')
      bef_res_nodes.size.should == 5
      bef_res_nodes[0].attributes['type'].nil?.should == true  # first resource type should not exist
      bef_res_nodes[1].attributes['type'].nil?.should == true # second resource type should not exist
      bef_res_nodes[2].attributes['type'].nil?.should == true # third resource type should not exist
      bef_res_nodes[3].attributes['type'].value.should == 'page' # fourth resource type should be set to page
      bef_res_nodes[4].attributes['type'].value.should == 'image' # last resource type should be set to image
            
      # check that each file node does not start with size, mimetype attributes
      bef_file_nodes=bef.xpath('//file')
      bef_file_nodes.size.should == 10
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
      aft_file_nodes.size.should == 10
      aft_file_nodes[0].attributes['size'].value.should == '63468'
      aft_file_nodes[0].attributes['mimetype'].value.should == 'image/tiff'
      # the first file node should preserve the existing publish/preserve/shelve attributes set in the incoming content metadata and not overwrite them with the default for tiff
      aft_file_nodes[0].attributes['publish'].value.should == 'yes'
      aft_file_nodes[0].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[0].attributes['shelve'].value.should == 'yes'

      # all other file nodes will have their publish/preserve/shelve attributes set
      aft_file_nodes[1].attributes['size'].value.should == '465'
      aft_file_nodes[1].attributes['mimetype'].value.should == 'image/jp2'
      aft_file_nodes[1].attributes['publish'].value.should == 'yes'
      aft_file_nodes[1].attributes['preserve'].value.should == 'no'
      aft_file_nodes[1].attributes['shelve'].value.should == 'yes'

      aft_file_nodes[2].attributes['size'].value.should == '450604'
      aft_file_nodes[2].attributes['mimetype'].value.should == 'audio/x-wav'
      aft_file_nodes[2].attributes['publish'].value.should == 'no'
      aft_file_nodes[2].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[2].attributes['shelve'].value.should == 'no'

      aft_file_nodes[3].attributes['size'].value.should == '3151'
      aft_file_nodes[3].attributes['mimetype'].value.should == 'application/pdf'
      aft_file_nodes[3].attributes['publish'].value.should == 'yes'
      aft_file_nodes[3].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[3].attributes['shelve'].value.should == 'yes'

      aft_file_nodes[4].attributes['size'].value.should == '3151'
      aft_file_nodes[4].attributes['mimetype'].value.should == 'application/pdf'
      aft_file_nodes[4].attributes['publish'].value.should == 'yes'
      aft_file_nodes[4].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[4].attributes['shelve'].value.should == 'yes'

      aft_file_nodes[5].attributes['size'].value.should == '63468'
      aft_file_nodes[5].attributes['mimetype'].value.should == 'image/tiff'
      aft_file_nodes[5].attributes['publish'].value.should == 'no'
      aft_file_nodes[5].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[5].attributes['shelve'].value.should == 'no'

      aft_file_nodes[6].attributes['size'].value.should == '42212'
      aft_file_nodes[6].attributes['mimetype'].value.should == 'audio/mpeg'
      aft_file_nodes[6].attributes['publish'].value.should == 'yes'
      aft_file_nodes[6].attributes['preserve'].value.should == 'no'
      aft_file_nodes[6].attributes['shelve'].value.should == 'yes'

      aft_file_nodes[7].attributes['size'].value.should == '63468'
      aft_file_nodes[7].attributes['mimetype'].value.should == 'image/tiff'
      aft_file_nodes[7].attributes['publish'].value.should == 'no'
      aft_file_nodes[7].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[7].attributes['shelve'].value.should == 'no'

      aft_file_nodes[8].attributes['size'].value.should == '63468'
      aft_file_nodes[8].attributes['mimetype'].value.should == 'image/tiff'
      aft_file_nodes[8].attributes['publish'].value.should == 'no'
      aft_file_nodes[8].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[8].attributes['shelve'].value.should == 'no'

      aft_file_nodes[9].attributes['size'].value.should == '63468'
      aft_file_nodes[9].attributes['mimetype'].value.should == 'image/tiff'
      aft_file_nodes[9].attributes['publish'].value.should == 'no'
      aft_file_nodes[9].attributes['preserve'].value.should == 'yes'
      aft_file_nodes[9].attributes['shelve'].value.should == 'no'            
            
      # check that each resource node end with a type="file" (i.e. was not changed)
      aft_res_nodes=aft.xpath('//resource')
      aft_res_nodes.size.should == 5
      aft_res_nodes[0].attributes['type'].value.should == 'file' # first resource type should be set to file (which is the default if it contains no images)
      aft_res_nodes[1].attributes['type'].value.should == 'file' # second resource type should be set to file (which is the default if it contains no images)
      aft_res_nodes[2].attributes['type'].nil?.should == true # third resource type should be nil still
      aft_res_nodes[3].attributes['type'].value.should == 'page' # fourth resource type should be set to page (which it started out as)
      aft_res_nodes[4].attributes['type'].value.should == 'image' # fifth resource type should be set to image (which it started out as)
      
      # check for imageData nodes being present for each file node that is an image
      bef.xpath('//file/imageData').size.should == 0
      aft.xpath('//file/imageData').size.should == 6

    end

  end

end
