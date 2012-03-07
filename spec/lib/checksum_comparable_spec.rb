class ChecksumComparableItem
  include Dor::Assembly::ChecksumComparable
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::ChecksumComparable do
  
  before :each do
    root_dir  = 'spec/test_input'
    dru       = 'aa111bb2222'
    cm_file   = Dor::Config.assembly.content_metadata_file_name

    @item = ChecksumComparableItem.new
    @item.druid        = Druid.new dru
    @item.root_dir     = root_dir
    @item.cm_file_name = File.join root_dir, @item.druid.path, cm_file

    # @fake_checksum_data = { :md5 => "a123", :sha1 => "567c" }
    # @parent_file_node   = @item.cm.xpath('//file').first

    # @exp_checksums = {
    #   "image111.tif" => {
    #     "md5"  => '7e40beb08d646044529b9138a5f1c796',
    #     "sha1" => 'ffed9bddf353e7a6445bdec9ae3ab8525a3ee690',
    #   },
    #   "image112.tif" => {
    #     "md5"  => '4e3cd24dd79f3ec91622d9f8e5ab5afa',
    #     "sha1" => '84e124b7ef4ec38d853c45e7b373b57201e28431',
    #   },
    # }

  end

  it "!!initialize" do
    @item.should be_a_kind_of ChecksumComparableItem
  end

end
