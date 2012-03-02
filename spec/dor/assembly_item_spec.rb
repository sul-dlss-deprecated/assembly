describe Dor::AssemblyItem do
  
  before :each do
    @dru      = 'aa111bb2222'
    @druid    = Druid.new @dru
    @root_dir = 'spec/test_input'
    @ai = new_item @druid
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

  end

end
