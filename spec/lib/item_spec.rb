describe Dor::Assembly::Item do
  
  before :each do
    cmf          = Dor::Config.assembly.cm_file_name
    root_dir     = Dor::Config.assembly.root_dir
    @dru         = 'aa111bb2222'
    @druid       = DruidTools::Druid.new @dru
    @exp_cm_file = "#{root_dir}/aa/111/bb/2222/#{cmf}"
  end

  describe "Initialization" do
    
    it "should know its druid, whether passed a string druid or a Druid object" do
      @item = Dor::Assembly::Item.new :druid => @druid
      @item.druid.should == @druid

      @item = Dor::Assembly::Item.new :druid => @druid
      @item.druid.druid.should == "druid:#{@dru}"
      @item.druid.id.should == @dru
    end

    it "should know the path to the content metadata file" do
      @item = Dor::Assembly::Item.new :druid => @druid
      @item.cm_file_name.should == @exp_cm_file
    end

  end

end
