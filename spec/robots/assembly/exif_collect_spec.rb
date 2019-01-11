require 'spec_helper'

RSpec.describe Robots::DorRepo::Assembly::ExifCollect do
  let(:druid) { 'aa222cc3333' }
  let(:robot) { described_class.new(druid: druid) }
  let(:type) { 'item' }

  let(:item) do
    instance_double(Dor::Assembly::Item,
                    is_item?: type == 'item')
  end

  before do
    allow(Dor::Assembly::Item).to receive(:new).and_return(item)
  end

  subject(:result) { robot.perform(druid) }

  context "when it's an item" do
    it 'collects exif' do
      Dor::Config.configure.assembly.items_only = true
      expect(item).to receive(:load_content_metadata)
      expect(item).to receive(:collect_exif_info)
      result
    end
  end

  context "when it's a set" do
    let(:type) { 'set' }
    before do
      Dor::Config.configure.assembly.items_only = items_only
    end
    context 'and configured for items_only' do
      let(:items_only) { true }

      it 'does not collect exif' do
        Dor::Config.configure.assembly.items_only = true
        expect(item).not_to receive(:load_content_metadata)
        expect(item).not_to receive(:collect_exif_info)
        result
      end
    end

    context 'and not configured for items_only' do
      let(:items_only) { false }

      it 'collects exif' do
        expect(item).to receive(:load_content_metadata)
        expect(item).to receive(:collect_exif_info)
        result
      end
    end
  end
end
