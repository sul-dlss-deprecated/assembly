require 'spec_helper'

describe Robots::DorRepo::Assembly::ContentMetadataCreate do

  before :each do
    @druid='aa111bb2222'
    setup_work_item(@druid)
    @r = Robots::DorRepo::Assembly::ContentMetadataCreate.new(:druid=>@druid)
  end

  it "should not create content metadata if type is not item" do
    setup_assembly_item(@druid,:collection)
    result = @r.perform(@work_item)
    expect(result.status).to eq('skipped')
    expect(result.note).to eq('object is not an item')
  end

  it "should not create content metadata if contentMetadata already exists" do
    setup_assembly_item(@druid,:item)
    allow(@assembly_item).to receive(:stub_content_metadata_exists?).and_return(true)
    allow(@assembly_item).to receive(:content_metadata_exists?).and_return(true)
    expect(@assembly_item).not_to receive(:create_content_metadata)
    expect(@assembly_item).not_to receive(:persist_content_metadata)
    result = @r.perform(@work_item)
    expect(result.status).to eq('skipped')
    expect(result.note).to eq("#{Dor::Config.assembly.cm_file_name} already exists")
  end
  
  it "should not create content metadata if stub contentMetadata does not exist" do
    setup_assembly_item(@druid,:item)
    allow(@assembly_item).to receive(:stub_content_metadata_exists?).and_return(false)
    allow(@assembly_item).to receive(:content_metadata_exists?).and_return(false)
    expect(@assembly_item).not_to receive(:create_content_metadata)
    expect(@assembly_item).not_to receive(:persist_content_metadata)
    result = @r.perform(@work_item)
    expect(result.status).to eq('skipped')
    expect(result.note).to eq("#{Dor::Config.assembly.stub_cm_file_name} does not exist")
  end  

  it "should create content metadata if stub contentMetadata exists and regular contentMetada does not yet" do
    setup_assembly_item(@druid,:item)
    allow(@assembly_item).to receive(:stub_content_metadata_exists?).and_return(true)
    allow(@assembly_item).to receive(:content_metadata_exists?).and_return(false)
    expect(@assembly_item).to receive(:create_content_metadata).once
    expect(@assembly_item).to receive(:persist_content_metadata).once
    result = @r.perform(@work_item)
    expect(result.status).to eq('completed')
  end  
  
end
