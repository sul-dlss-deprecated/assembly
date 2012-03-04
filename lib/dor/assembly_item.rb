module Dor

  class AssemblyItem

    include Dor::Checksumable

    attr_accessor(
      :druid, 
      :root_dir, 
      :persist,
      :path,
      :ainfo_file,
      :ainfo,
      :checksums,
      :checksum_types,
      :files
    )

    def initialize(params = {})
      @root_dir = params[:root_dir]
      @persist  = params[:persist]
      @druid    = params[:druid]
      setup
      load_assembly_info
    end

    def setup
      @druid          = Druid.new(@druid) unless @druid.class == Druid
      @path           = File.join @root_dir, @druid.tree
      @ainfo_file     = File.join @path, 'assembly.yml'
      @ainfo          = nil
      @checksums      = {}
      @checksum_types = [:md5, :sha1]
      @files          = []
    end

    def load_assembly_info
      @ainfo = YAML.load_file @ainfo_file
      @files = @ainfo[:contentMetadata][:resource].map { |r| r[:file][:id] }
      @files = @files.map { |f| File.join @path, f }
    end

    def persist_assembly_info(ai_type)
      # TODO: persist_assembly_info(): implement.
    end

  end
  
end

