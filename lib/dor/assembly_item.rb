module Dor

  class AssemblyItem

    include Dor::Checksumable

    attr_accessor(
      :druid, 
      :root_dir, 
      :path, 
      :checksums,
      :ainfo,
      :files
    )

    def initialize(params = {})
      @druid     = params[:druid]
      @root_dir  = params[:root_dir] || 'spec/test_input'
      setup
      load_assembly_yml
    end

    def setup
      @druid          = Druid.new(@druid) unless @druid.class == Druid
      @path           = File.join @root_dir, @druid.tree
      @ainfo_file     = File.join @path, 'assembly.yml'
      @checksums      = nil
      @ainfo          = nil
      @checksum_types = [:md5, :sha1]
    end

    def load_assembly_yml
      @ainfo = YAML.load_file @ainfo_file
      @files = @ainfo[:contentMetadata][:resource].map { |r| r[:file][:id] }
      @files = @files.map { |f| File.join @path, f }
    end

  end
  
end

