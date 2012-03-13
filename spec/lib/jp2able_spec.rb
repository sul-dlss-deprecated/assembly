class Jp2ableItem
  include Dor::Assembly::Jp2able
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Jp2able do
  
  before :each do
    basic_setup 'aa111bb2222'
  end

  def basic_setup(dru)
    root_dir     = Dor::Config.assembly.root_dir
    cm_file_name = Dor::Config.assembly.cm_file_name

    @item              = Jp2ableItem.new
    @item.druid        = Druid.new dru
    @item.root_dir     = root_dir
    @item.cm_file_name = File.join root_dir, @item.druid.path, cm_file_name

    @dummy_xml            = '<contentMetadata><resource></resource></contentMetadata>'
  end
 
  describe '#Jp2ableItem' do

    it 'should be able to initialize our testing object' do
      @item.should be_a_kind_of Jp2ableItem
    end
    
  end

  describe '#create_jp2s' do
  
    before(:each) do
      # Set cm_handle so that the call to create_jp2s does not
      # modify our testing inputs.
      @tmpfile = Tempfile.new 'persist_content_metadata_', 'tmp'
      @item.cm_handle = @tmpfile
    end

    it 'should ...' do
      basic_setup 'aa111bb2222'
      @item.load_content_metadata
      @item.create_jp2s

      # @item.file_nodes.each do |fnode|
      #   file_name = fnode['id']
      #   cnodes    = fnode.xpath './checksum'
      #   checksums = Hash[ cnodes.map { |cn| [cn['type'], cn.content] } ]
      #   checksums.should == @exp_checksums[file_name]
      # end
    end

  end

  describe "Filters" do
    
    it "#all_images should load the correct N of Assembly::Image objects" do
      basic_setup 'aa111bb2222'
      @item.load_content_metadata
      imgs = @item.all_images
      imgs.size.should == 2
      imgs.each { |i| i.should be_instance_of Assembly::Image }

      basic_setup 'cc333dd4444'
      @item.load_content_metadata
      imgs = @item.all_images
      imgs.size.should == 2
    end

    it "#relevant_images should filter out non-approved file types" do
      basic_setup 'cc333dd4444'
      @item.load_content_metadata
      imgs = @item.relevant_images
      imgs.size.should == 1
    end

  end

  describe '#add_jp2_file_node' do
    
    it 'should add the expected <file> node to XML' do
      exp_xml = <<-END.gsub(/^ {8}/, '')
        <?xml version="1.0"?>
        <contentMetadata>
          <resource>
            <file preserve="yes" publish="no" shelve="no" id="foo.tif"/>
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
