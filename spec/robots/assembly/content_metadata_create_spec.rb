require 'spec_helper'

RSpec.describe Robots::DorRepo::Assembly::ContentMetadataCreate do
  before do
    @druid = 'aa111bb2222'
    @r = Robots::DorRepo::Assembly::ContentMetadataCreate.new(:druid => @druid)
  end

  it "should call the create_content_metadata method" do
    setup_assembly_item(@druid, :item)
    expect(@assembly_item).to receive(:create_content_metadata)
    @r.perform(@assembly_item)
  end
end
