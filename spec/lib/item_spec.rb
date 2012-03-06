describe Dor::Assembly::Item do
  
  before :each do
    @dru           = 'aa111bb2222'
    @druid         = Druid.new @dru
    @root_dir      = Dor::Config.assembly.root
    @ai            = new_assembly_item @druid
  end

  def new_assembly_item(druid)
    # TODO: new_assembly_item: use a StringIO for cm_handle.
    @ai = Dor::Assembly::Item.new(
      :druid     => druid,
      :cm_handle => File.open('tmp/out.xml', 'a')
    )
  end
 
  describe "initialization" do
    
    it "can be instantiated" do
      @ai.should be_kind_of Dor::Assembly::Item
    end
    
    it "knows its druid, whether passed a string druid or a Druid object" do
      @ai.druid.should == @druid
      @ai = new_assembly_item @dru
      @ai.druid.druid.should == @dru
    end

    it "knows its druid_tree_path" do
      @ai.druid_tree_path.should == File.join(@root_dir, @druid.tree)
    end

  end

end
