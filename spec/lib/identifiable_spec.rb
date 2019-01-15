# frozen_string_literal: true

require 'spec_helper'

describe Dor::Assembly::Identifiable do
  it 'should return the object type from identityMetadata datastream' do
    @dru = 'aa111bb2222'
    @druid = DruidTools::Druid.new @dru
    dor_item = double('dor_item')
    identity_metadata = double('identity_metadata')
    allow(identity_metadata).to receive(:objectType).and_return(['item'])
    allow(dor_item).to receive(:identityMetadata).and_return(identity_metadata)
    @item = Dor::Assembly::Item.new druid: @dru
    allow(@item).to receive(:object).and_return(dor_item)
    expect(@item.object_type).to eq('item')
  end

  it 'should return item? as true for object type == item' do
    @dru = 'aa111bb2222'
    @item = Dor::Assembly::Item.new druid: @dru
    allow(@item).to receive(:object_type).and_return('item')
    expect(@item).to be_item
  end

  it 'should return item? as false for object type == set' do
    @dru = 'aa111bb2222'
    @item = Dor::Assembly::Item.new druid: @dru
    allow(@item).to receive(:object_type).and_return('set')
    expect(@item).not_to be_item
  end

  it 'should return item? as false for object type not known' do
    @dru = 'aa111bb2222'
    @item = Dor::Assembly::Item.new druid: @dru
    allow(@item).to receive(:object_type).and_return('')
    expect(@item).not_to be_item
  end
end
