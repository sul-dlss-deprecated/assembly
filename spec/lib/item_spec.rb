describe Dor::Assembly::Item do
  
  def basic_setup(dru)
    @cm_file_name = Dor::Config.assembly.cm_file_name
    @root_dir     = Dor::Config.assembly.root_dir
    @druid       = DruidTools::Druid.new dru
  end

  describe "Initialization" do
    
    it "should know its druid, whether passed a string druid or a Druid object" do
      @dru         = 'aa111bb2222'
      basic_setup(@dru)
      @item = Dor::Assembly::Item.new :druid => @druid
      @item.druid.should == @druid
      @item.druid.druid.should == "druid:#{@dru}"
      @item.druid.id.should == @dru
    end

    it "should know the path to the content metadata file" do
      @dru         = 'aa111bb2222'
      basic_setup(@dru)
      @item = Dor::Assembly::Item.new :druid => @druid
      exp_cm_file = "#{@root_dir}/aa/111/bb/2222/#{@cm_file_name}"
      @item.cm_file_name.should == exp_cm_file
    end

    it "should know the path to the content metadata file in the new location" do
      @dru         = 'gg111bb2222'
      basic_setup(@dru)
      @item = Dor::Assembly::Item.new :druid => @druid
      exp_cm_file = "#{@root_dir}/gg/111/bb/2222/gg111bb2222/metadata/#{@cm_file_name}"
      @item.cm_file_name.should == exp_cm_file
    end

  end

end
