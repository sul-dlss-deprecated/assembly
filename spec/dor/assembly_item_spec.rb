describe Dor::AssemblyItem do
  
  before :each do
    # TODO: test_input: need a test object with more than one image.
    @dru       = 'aa111bb2222'
    @druid     = Druid.new @dru
    @root_dir  = 'spec/test_input'
    @ai        = new_item @druid
    @exp_files = [File.join @ai.path, 'image2.tif']
  end

  def new_item(druid)
    @ai = Dor::AssemblyItem.new(
      :druid    => druid,
      :root_dir => @root_dir
    )
  end
 
  describe "initialization" do
    
    it "can be instantiated" do
      @ai.should be_kind_of Dor::AssemblyItem
    end
    
    it "knows its druid, whether passed a string druid or a Druid object" do
      @ai.druid.should == @druid
      @ai = new_item @dru
      @ai.druid.druid.should == @dru
    end

    it "knows its path" do
      @ai.path.should == File.join(@root_dir, @druid.tree)
    end

    it "can get names of files to be processed from assembly.yml" do
      @ai.files.should == @exp_files
    end

  end

  describe "computing checksums" do

    it "can get a Checksum::Tools object" do
      @ai.checksums.should == nil
      @ai.compute_checksums
      @ai.checksums.should == [{
        :md5  => '7e40beb08d646044529b9138a5f1c796',
        :sha1 => 'ffed9bddf353e7a6445bdec9ae3ab8525a3ee690',
      }]
    end
  end

end
