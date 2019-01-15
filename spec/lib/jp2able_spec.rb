# frozen_string_literal: true

require 'spec_helper'

describe Dor::Assembly::Jp2able do
  def basic_setup(dru, root_dir = Dor::Config.assembly.root_dir)
    @cm_file_name = Dor::Config.assembly.cm_file_name
    @item              = Dor::Assembly::Item.new(druid: dru)
    @item.root_dir     = root_dir
    @item.path_to_object = nil # this will allow us to override the path to the object to use the root_dir we overrode above
    #  it is only necessary to clear this accessor in test setup since it otherwise gets set in the initializer and cached
    @dummy_xml = '<contentMetadata><resource></resource></contentMetadata>'
  end

  describe '#Jp2ableItem' do
    it 'should be able to initialize our testing object' do
      basic_setup 'aa111bb2222', TMP_ROOT_DIR
      expect(@item).to be_a_kind_of Dor::Assembly::Item
    end
  end

  describe '#create_jp2s' do
    before(:each) do
      clone_test_input TMP_ROOT_DIR
    end

    it 'should not create and jp2 files when resource type is not specified' do
      basic_setup 'aa111bb2222', TMP_ROOT_DIR

      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.path_to_content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }

      # Only tifs should exist.
      expect(@item.file_nodes.size).to eq(3)
      expect(tifs.all?  { |t| File.file? t }).to eq(true)
      expect(jp2s.none? { |j| File.file? j }).to eq(true)

      # We now have jp2s since all resource types = image
      create_jp2s
      files = get_filenames(@item)
      expect(@item.file_nodes.size).to eq(6)
      expect(count_file_types(files, '.tif')).to eq(3)
      expect(count_file_types(files, '.jp2')).to eq(3)
    end

    it 'should create jp2 files only for resource type image or page' do
      basic_setup 'ff222cc3333', TMP_ROOT_DIR
      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.path_to_content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }
      bef_files = get_filenames(@item)

      # there should be 10 file nodes in total
      expect(@item.file_nodes.size).to eq(10)
      expect(count_file_types(bef_files, '.tif')).to eq(5)
      expect(count_file_types(bef_files, '.jp2')).to eq(1)

      create_jp2s
      # we now have two extra jps, only for the resource nodes that had type=image or page specified, but not for the others
      expect(@item.file_nodes.size).to eq(12)
      aft_files = get_filenames(@item)
      expect(count_file_types(aft_files, '.tif')).to eq(5)
      expect(count_file_types(aft_files, '.jp2')).to eq(3)

      # Read the XML file and check the file names.
      xml = Nokogiri::XML File.read(@item.cm_file_name)
      file_nodes = xml.xpath '//resource/file'
      expected_results = ['file111.mp3', 'file111.pdf', 'file111.wav', 'file112.pdf', 'image111.jp2',
                          'image111.tif', 'image112.tif', 'image113.tif', 'image114.jp2', 'image114.tif', 'image115.jp2', 'image115.tif']
      expect(file_nodes.map { |fn| fn['id'] }.sort).to eq(expected_results)
    end

    it 'should create jp2 files only for resource type image or page in new location' do
      basic_setup 'gg111bb2222', TMP_ROOT_DIR
      @item.cm_file_name = @item.path_to_metadata_file(@cm_file_name)
      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.path_to_content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }
      bef_files = get_filenames(@item)

      # there should be 3 file nodes in total
      expect(@item.file_nodes.size).to eq(3)
      expect(count_file_types(bef_files, '.tif')).to eq(3)
      expect(count_file_types(bef_files, '.jp2')).to eq(0)

      create_jp2s
      # we now have three jps
      expect(@item.file_nodes.size).to eq(6)
      aft_files = get_filenames(@item)
      expect(count_file_types(aft_files, '.tif')).to eq(3)
      expect(count_file_types(aft_files, '.jp2')).to eq(3)

      # Read the XML file and check the file names.
      xml = Nokogiri::XML File.read(@item.cm_file_name)
      file_nodes = xml.xpath '//resource/file'
      expect(file_nodes.map { |fn| fn['id'] }.sort).to eq(['image111.jp2', 'image111.tif', 'image112.jp2', 'image112.tif', 'sub/image113.jp2', 'sub/image113.tif'])
    end

    it 'should not overwrite existing jp2s but should not fail either' do
      Dor::Config.assembly.overwrite_jp2 = false

      basic_setup 'ff222cc3333', TMP_ROOT_DIR

      # copy an existing jp2
      source_jp2 = File.join TMP_ROOT_DIR, 'ff/222/cc/3333', 'image111.jp2'
      copy_jp2 = File.join TMP_ROOT_DIR, 'ff/222/cc/3333', 'image115.jp2'
      system "cp #{source_jp2} #{copy_jp2}"

      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.path_to_content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }
      bef_files = get_filenames(@item)

      # there should be 10 file nodes in total
      expect(@item.file_nodes.size).to eq(10)
      expect(count_file_types(bef_files, '.tif')).to eq(5)
      expect(count_file_types(bef_files, '.jp2')).to eq(1)

      expect(File.exists?(copy_jp2)).to eq(true)

      create_jp2s
      # we now have only one extra jp2, only for the resource nodes that had type=image or page specified, since one was not created because it was already there
      expect(@item.file_nodes.size).to eq(11)
      aft_files = get_filenames(@item)
      expect(count_file_types(aft_files, '.tif')).to eq(5)
      expect(count_file_types(aft_files, '.jp2')).to eq(2)

      # cleanup copied jp2
      system "rm #{copy_jp2}"
    end

    it 'should overwrite existing jp2s but should not fail either' do
      Dor::Config.assembly.overwrite_jp2 = true

      basic_setup 'ff222cc3333', TMP_ROOT_DIR

      # copy an existing jp2
      source_jp2 = File.join TMP_ROOT_DIR, 'ff/222/cc/3333', 'image111.jp2'
      copy_jp2 = File.join TMP_ROOT_DIR, 'ff/222/cc/3333', 'image115.jp2'
      system "cp #{source_jp2} #{copy_jp2}"

      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.path_to_content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }
      bef_files = get_filenames(@item)

      # there should be 10 file nodes in total
      expect(@item.file_nodes.size).to eq(10)
      expect(count_file_types(bef_files, '.tif')).to eq(5)
      expect(count_file_types(bef_files, '.jp2')).to eq(1)

      expect(File.exists?(copy_jp2)).to eq(true)

      create_jp2s

      expect(@item.file_nodes.size).to eq(11)
      aft_files = get_filenames(@item)
      expect(count_file_types(aft_files, '.tif')).to eq(5)
      expect(count_file_types(aft_files, '.jp2')).to eq(2)

      # cleanup copied jp2
      system "rm #{copy_jp2}"
    end

    it 'should not overwrite existing jp2s when there is a DPG style jp2 already there' do
      Dor::Config.assembly.overwrite_dpg_jp2 = false

      basic_setup 'hh222cc3333', TMP_ROOT_DIR

      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.path_to_content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }
      bef_files = get_filenames(@item)

      # there should be 6 file nodes in total to start
      expect(@item.file_nodes.size).to eq(6)
      expect(count_file_types(bef_files, '.tif')).to eq(5)
      expect(count_file_types(bef_files, '.jp2')).to eq(1)

      create_jp2s

      # we now have three extra jp2, one for each tif that didn't have a matching dpg style jp2
      # even if the jp2 does not exist in the original content metadata, if a matching one is found, a derivative won't be created
      expect(@item.file_nodes.size).to eq(9) # there are 9 total nodes, 4 jp2 and 5 tif
      aft_files = get_filenames(@item)
      expect(count_file_types(aft_files, '.tif')).to eq(5)
      expect(count_file_types(aft_files, '.jp2')).to eq(4)
    end

    it 'should overwrite existing jp2s when there is a DPG style jp2 already there' do
      Dor::Config.assembly.overwrite_dpg_jp2 = true

      basic_setup 'hh222cc3333', TMP_ROOT_DIR

      @item.load_content_metadata
      tifs = @item.file_nodes.map { |fn| @item.path_to_content_file fn['id'] }
      jp2s = tifs.map { |t| t.sub /\.tif$/, '.jp2' }
      bef_files = get_filenames(@item)

      # there should be 6 file nodes in total to start
      expect(@item.file_nodes.size).to eq(6)
      expect(count_file_types(bef_files, '.tif')).to eq(5)
      expect(count_file_types(bef_files, '.jp2')).to eq(1)

      create_jp2s

      expect(@item.file_nodes.size).to eq(11)
      aft_files = get_filenames(@item)
      expect(count_file_types(aft_files, '.tif')).to eq(5)
      expect(count_file_types(aft_files, '.jp2')).to eq(6)
    end
  end

  describe '#add_jp2_file_node' do
    it 'should add a <file> node to XML if the resource type is not specified' do
      basic_setup 'aa111bb2222', TMP_ROOT_DIR
      @item.cm_file_name = @item.path_to_metadata_file(@cm_file_name)

      exp_xml = <<-END.gsub(/^ {8}/, '')
        <?xml version="1.0"?>
        <contentMetadata>
          <resource>
            <file id="foo.tif"/>
          </resource>
        </contentMetadata>
      END
      exp_xml = noko_doc exp_xml

      @item.cm = noko_doc @dummy_xml
      resource_node = @item.cm.xpath('//resource').first

      @item.add_jp2_file_node resource_node, 'foo.tif'
      expect(@item.cm).to be_equivalent_to exp_xml
    end
  end

  def create_jp2s
    skip 'Missing kdu_compress utility' if kdu_missing?

    @item.create_jp2s
  end
end
