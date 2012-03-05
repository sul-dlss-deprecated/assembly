module Dor

  class AssemblyItem

    include Dor::Checksumable

    attr_accessor(
      :druid, 
      :root_dir, 
      :path,
      :ainfo_file_name,
      :ainfo_file_h,
      :ainfo,
      :checksums,
      :checksum_types,
      :files
    )

    def initialize(params = {})
      @root_dir     = params[:root_dir]
      @ainfo_file_h = params[:ainfo_file_h]
      @druid        = params[:druid]
      setup
      load_assembly_info
    end

    def setup
      @druid           = Druid.new(@druid) unless @druid.class == Druid
      @path            = File.join @root_dir, @druid.tree
      @ainfo_file_name = File.join @path, 'assembly.yml'
      @ainfo           = nil
      @checksums       = {}
      @checksum_types  = [:md5, :sha1]
      @files           = []
    end

    def load_assembly_info
      # TODO: load_assembly_info: store the resources as AssemblyItemResource.
      # TODO: convert YAML file to XML.
      @ainfo = YAML.load_file @ainfo_file_name
      @files = @ainfo[:contentMetadata][:resource].map { |r| r[:file][:id] }
      @files = @files.map { |f| File.join @path, f }
    end

    def persist_assembly_info(ai_type)
      # TODO: persist_assembly_info(): implement.
      # @ainfo_file_h ||= File.open @ainfo_file_name, 'w'
      # YAML.dump @ainfo, @ainfo_file_h
    end

  end
  
end

