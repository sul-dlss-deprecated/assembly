class Jp2ableItem
  include Dor::Assembly::Jp2able
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::Jp2able do
  
  before :each do

    dru          = 'aa111bb2222'
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
      @item.load_content_metadata

      # @item.file_nodes.each do |fnode|
      #   file_name = fnode['id']
      #   cnodes    = fnode.xpath './checksum'
      #   checksums = Hash[ cnodes.map { |cn| [cn['type'], cn.content] } ]
      #   checksums.should == @exp_checksums[file_name]
      # end
    end

  end

  describe '#add_jp2_file_node' do
    
    it 'should add the expected file node to the XML' do
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
