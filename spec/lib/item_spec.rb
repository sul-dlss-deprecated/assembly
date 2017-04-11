require 'spec_helper'

describe Dor::Assembly::Item do

  describe "Initialization" do

    it "should know its druid, whether passed a string druid or a Druid object" do
      @dru         = 'aa111bb2222'
      @druid       = DruidTools::Druid.new @dru
      @item = Dor::Assembly::Item.new :druid => @druid
      expect(@item.druid).to eq(@druid)
      expect(@item.druid.druid).to eq("druid:#{@dru}")
      expect(@item.druid.id).to eq(@dru)
    end

    it "should provide access to the object from dor" do
      @item = Dor::Assembly::Item.new :druid => "druid:aa111bb2222"
      dor_item=double("dor_item")
      allow(Dor).to receive(:find).and_return(dor_item)
      expect(@item.object).to eq(dor_item)
    end

    it "should raise an error if the object folder cannot be found" do
      @dru         = 'xx111yy2222'
      @druid       = DruidTools::Druid.new @dru
      exp_msg = "Path to object xx111yy2222 not found in any of the root directories: spec/test_input,spec/test_input2"
      expect {@item = Dor::Assembly::Item.new :druid => @druid}.to raise_error RuntimeError, exp_msg
    end

  end

end
