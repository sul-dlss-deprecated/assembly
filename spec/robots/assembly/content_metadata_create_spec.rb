require 'spec_helper'

describe Robots::DorRepo::Assembly::ContentMetadataCreate do

  before :each do
    @druid='aa111bb2222'
    setup_work_item(@druid)
    @r = Robots::DorRepo::Assembly::ContentMetadataCreate.new(:druid=>@druid)
  end

  it "should call the create_content_metadata method" do
    setup_assembly_item(@druid,:item)
    expect(@assembly_item).to receive(:create_content_metadata)
    @r.perform(@work_item)
  end

end
