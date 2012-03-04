describe Dor::AssemblyItem do
  
  before :each do
    # TODO: test_input: need a copy of test_input than can be modified.
    @dru           = 'aa111bb2222'
    @druid         = Druid.new @dru
    @root_dir      = 'spec/test_input'
    @ai            = new_item @druid
    @exp_checksums = {
      File.join(@ai.path, "image111.tif") => {
        :md5  => '7e40beb08d646044529b9138a5f1c796',
        :sha1 => 'ffed9bddf353e7a6445bdec9ae3ab8525a3ee690',
      },
      File.join(@ai.path, "image112.tif") => {
        :md5  => '4e3cd24dd79f3ec91622d9f8e5ab5afa',
        :sha1 => '84e124b7ef4ec38d853c45e7b373b57201e28431',
      },
    }
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
      @ai.files.should == @exp_checksums.keys.sort
    end

  end

  describe "computing checksums" do

    it "compute the correct checksums" do
      @ai.checksums.should == {}
      @ai.compute_checksums
      @ai.checksums.should == @exp_checksums
    end
  end

end
