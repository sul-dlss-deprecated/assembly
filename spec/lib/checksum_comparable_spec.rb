class ChecksumComparableItem
  include Dor::Assembly::ChecksumComparable
  include Dor::Assembly::ContentMetadata
end

describe Dor::Assembly::ChecksumComparable do
  
  def setup(dru)
    root_dir           = Dor::Config.assembly.root_dir
    cm_file_name       = Dor::Config.assembly.cm_file_name

    @item              = ChecksumComparableItem.new
    @item.druid        = Druid.new dru
    @item.root_dir     = root_dir
    @item.cm_file_name = File.join root_dir, @item.druid.path, cm_file_name

    @item.load_content_metadata
  end

  describe "#ChecksumComparableItem" do

    it "should be able to initialize our testing object" do
      setup 'aa111bb2222'
      @item.should be_a_kind_of ChecksumComparableItem
    end
    
  end

  describe "###compare_checksums: successful comparisons" do

    it "should succeed if checksums agree, with the correct N of successes" do
      setup 'aa111bb2222'
      @item.compare_checksums.should == 3
    end

    it "should return 0 if no comparisons are made" do
      setup 'cc333dd4444'
      @item.compare_checksums.should == 0
    end

  end

  describe "#compare_checksums: checksum disagreements" do

    it "should raise error if checksums disagree" do
      setup 'ee555ff6666'
      p = lambda { @item.compare_checksums }
      p.should raise_error StandardError, /^Checksums disagree/
    end

  end

end
