describe Dor::Assembly::Item do
  
  before :each do
    @dru           = 'aa111bb2222'
    @druid         = Druid.new @dru
    @root_dir      = Dor::Config.assembly.root
    @ai            = new_assembly_item @druid
    @exp_checksums = {
      File.join(@ai.path, "image111.tif") => {
        :md5  => '7e40beb08d646044529b9138a5f1c796',
        :sha1 => 'ffed9bddf353e7a6445bdec9ae3ab8525a3ee690',
      },
      File.join(@ai.path, "image112.tif") => {
        :md5  => '4e3cd24dd79f3ec91622d9f8e5ab5afa',
        :sha1 => '84e124b7ef4ec38d853c45e7b373b57201e28431',
      },
    }
  end

  def new_assembly_item(druid)
    # TODO: new_assembly_item: use a StringIO for cm_handle.
    @ai = Dor::Assembly::Item.new(
      :druid     => druid,
      :cm_handle => File.open('tmp/temp_out.xml', 'a')
    )
  end
 
  describe "initialization" do
    
    it "can be instantiated" do
      @ai.should be_kind_of Dor::Assembly::Item
    end
    
    it "knows its druid, whether passed a string druid or a Druid object" do
      @ai.druid.should == @druid
      @ai = new_assembly_item @dru
      @ai.druid.druid.should == @dru
    end

    it "knows its path" do
      @ai.path.should == File.join(@root_dir, @druid.tree)
    end

  end

  describe "content metadata interface" do

    it "can get paths of files to be processed" do
      @ai.all_file_paths.should == @exp_checksums.keys.sort
    end

  end

  describe "computing checksums" do

    it "compute the correct checksums" do
      # TODO: assertions for expected checksums.
      # TODO: move to checksmable_spec.rb, along with exp_checksums.
      @ai.compute_checksums
    end

  end

end
