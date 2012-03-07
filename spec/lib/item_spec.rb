describe Dor::Assembly::Item do
  
  before :each do
    @dru      = 'aa111bb2222'
    @druid    = Druid.new @dru
    @root_dir = 'spec/test_input'
  end

  describe "initialization" do
    
    it "item should know its druid, whether passed a string druid or a Druid object" do
      @item = Dor::Assembly::Item.new :druid => @druid
      @item.druid.should == @druid

      @item = Dor::Assembly::Item.new :druid => @druid
      @item.druid.druid.should == @dru
    end

    it "item should know the path to the content metadata file" do
      @item = Dor::Assembly::Item.new :druid => @druid
      exp_cm_file = 'spec/test_input/aa/111/bb/2222/' + Dor::Config.assembly.content_metadata_file_name
      @item.cm_file_name.should == exp_cm_file
    end

  end

end
