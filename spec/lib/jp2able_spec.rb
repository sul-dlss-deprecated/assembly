class Jp2ableItem
  include Dor::Assembly::Jp2able
  include Dor::Assembly::ContentMetadata
  include Dor::Assembly::Findable
end

describe Dor::Assembly::Jp2able do

  def basic_setup(dru, root_dir = nil)
    root_dir           = root_dir || Dor::Config.assembly.root_dir
    @cm_file_name       = Dor::Config.assembly.cm_file_name
    @item              = Jp2ableItem.new
    @item.druid        = DruidTools::Druid.new dru
    @item.root_dir     = root_dir
    @dummy_xml         = '<contentMetadata><resource></resource></contentMetadata>'
  end
 
  describe '#Jp2ableItem' do
    it 'should be able to initialize our testing object' do
      basic_setup 'aa111bb2222', TMP_ROOT_DIR
      @item.should be_a_kind_of Jp2ableItem
    end
  end

  describe '#create_jp2s' do
  
    before(:each) do
      clone_test_input TMP_ROOT_DIR
    end

    it 'should not create and jp2 files when resource type is not specified' do
      basic_setup 'aa111bb2222', TMP_ROOT_DIR
      @item.cm_file_name = @item.metadata_file(@cm_file_name)

      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }

      # Only tifs should exist.
      @item.file_nodes.size.should == 3
      tifs.all?  { |t| File.file? t }.should == true
      jp2s.none? { |j| File.file? j }.should == true

      # We now have jp2s since all resource types = image
      @item.create_jp2s
      files = get_filenames(@item)      
      @item.file_nodes.size.should == 6
      count_file_types(files,'.tif').should == 3
      count_file_types(files,'.jp2').should == 3
    end

    it 'should create jp2 files only for resource type image or page' do
      basic_setup 'ff222cc3333', TMP_ROOT_DIR
      @item.cm_file_name = @item.metadata_file(@cm_file_name)
      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }
      bef_files = get_filenames(@item)

      # there should be 10 file nodes in total
      @item.file_nodes.size.should == 10
      count_file_types(bef_files,'.tif').should == 5
      count_file_types(bef_files,'.jp2').should == 1

      @item.create_jp2s
      # we now have two extra jps, only for the resource nodes that had type=image or page specified, but not for the others
      @item.file_nodes.size.should == 12
      aft_files = get_filenames(@item)
      count_file_types(aft_files,'.tif').should == 5
      count_file_types(aft_files,'.jp2').should == 3

      # Read the XML file and check the file names.
      xml = Nokogiri::XML File.read(@item.cm_file_name)
      file_nodes = xml.xpath "//resource/file"
      file_nodes.map { |fn| fn['id'] }.sort.should == ["file111.mp3", "file111.pdf", "file111.wav", "file112.pdf", "image111.jp2", "image111.tif", "image112.tif", "image113.tif", "image114.jp2", "image114.tif", "image115.jp2", "image115.tif"]
      
    end

    it 'should create jp2 files only for resource type image or page in new location' do
      basic_setup 'gg111bb2222', TMP_ROOT_DIR
      @item.cm_file_name = @item.metadata_file(@cm_file_name)
      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }
      bef_files = get_filenames(@item)

      # there should be 3 file nodes in total
      @item.file_nodes.size.should == 3
      count_file_types(bef_files,'.tif').should == 3
      count_file_types(bef_files,'.jp2').should == 0

      @item.create_jp2s
      # we now have three jps
      @item.file_nodes.size.should == 6
      aft_files = get_filenames(@item)
      count_file_types(aft_files,'.tif').should == 3
      count_file_types(aft_files,'.jp2').should == 3

      # Read the XML file and check the file names.
      xml = Nokogiri::XML File.read(@item.cm_file_name)
      file_nodes = xml.xpath "//resource/file"
      file_nodes.map { |fn| fn['id'] }.sort.should == ["image111.jp2", "image111.tif", "image112.jp2", "image112.tif", "sub/image113.jp2", "sub/image113.tif"]
      
    end
    
    it 'should not overwrite existing jp2s but should not fail either' do

      basic_setup 'ff222cc3333', TMP_ROOT_DIR
      @item.cm_file_name = @item.metadata_file(@cm_file_name)
      
      # copy an existing jp2 
      source_jp2=File.join TMP_ROOT_DIR, 'ff/222/cc/3333','image111.jp2'
      copy_jp2=File.join TMP_ROOT_DIR, 'ff/222/cc/3333','image115.jp2'
      system "cp #{source_jp2} #{copy_jp2}"
      
      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }
      bef_files = get_filenames(@item)

      # there should be 10 file nodes in total
      @item.file_nodes.size.should == 10
      count_file_types(bef_files,'.tif').should == 5
      count_file_types(bef_files,'.jp2').should == 1
      
      File.exists?(copy_jp2).should == true
       
      @item.create_jp2s
      # we now have only one extra jp2, only for the resource nodes that had type=image or page specified, since one was not created because it was already there
      @item.file_nodes.size.should == 11
      aft_files = get_filenames(@item)
      count_file_types(aft_files,'.tif').should == 5
      count_file_types(aft_files,'.jp2').should == 2
      
      # cleanup copied jp2
      system "rm #{copy_jp2}"

    end

  end

  describe '#add_jp2_file_node' do
    
    it 'should add a <file> node to XML if the resource type is not specified' do
      basic_setup 'aa111bb2222', TMP_ROOT_DIR
      @item.cm_file_name = @item.metadata_file(@cm_file_name)
           
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
