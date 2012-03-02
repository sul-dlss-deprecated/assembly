describe Dor::AssemblyItem do
  
  before :each do
    @dru      = 'aa111bb2222'
    @druid    = Druid.new @dru
    @root_dir = 'spec/test_input'
    @ai       = new_item @druid
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

    it "can load assembly.yml" do
      #
    end

  end

  describe "computing checksums" do

    it "can get a Checksum::Tools object" do
      # TODO: write spec to prove that compute_checksums() is working.
      # @ai.checksums.should == { :md5 => nil, :sha1 => nil }
      # @ai.compute_checksums
      # @ai.checksums.should == {
      #   :md5  => 'c7a6c9e44794b23adc0e9ce4a350ce63',
      #   :sha1 => '1fd32b6caa7cefaaca478bfdc3b77cb8bad8ccac',
      # }
    end
  end

end
