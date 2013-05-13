describe Dor::Assembly::Item do

  describe "Initialization" do
    
    it "should know its druid, whether passed a string druid or a Druid object" do
      @dru         = 'aa111bb2222'
      @druid       = DruidTools::Druid.new @dru
      @item = Dor::Assembly::Item.new :druid => @druid
      @item.druid.should == @druid
      @item.druid.druid.should == "druid:#{@dru}"
      @item.druid.id.should == @dru
    end

    it "should raise an error if the object folder cannot be found" do
      @dru         = 'xx111yy2222'
      @druid       = DruidTools::Druid.new @dru
      exp_msg = "Path to object xx111yy2222 not found in any of the root directories: spec/test_input,spec/test_input2"
      lambda {@item = Dor::Assembly::Item.new :druid => @druid}.should raise_error RuntimeError, exp_msg
    end
    
    it "should return is_item? as true for object type == item" do
      @dru         = 'aa111bb2222'
      @item = Dor::Assembly::Item.new :druid => @dru
      @item.stub(:object_type).and_return('item')
      @item.is_item?.should be_true
    end

    it "should return is_item? as false for object type == set" do
      @dru         = 'aa111bb2222'
      @item = Dor::Assembly::Item.new :druid => @dru
      @item.stub(:object_type).and_return('set')
      @item.is_item?.should be_false
    end

    it "should return is_item? as false for object type not known" do
      @dru         = 'aa111bb2222'
      @item = Dor::Assembly::Item.new :druid => @dru
      @item.stub(:object_type).and_return('')
      @item.is_item?.should be_false
    end
    
  end

end
