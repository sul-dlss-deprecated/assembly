module Dor

  class AssemblyItem

    include Dor::Checksumable

    attr_accessor :druid, :root_dir, :path

    def initialize(params = {})
      @druid    = params[:druid]
      @root_dir = params[:root_dir] || ''
      @path     = ''
      setup
    end

    def setup
      @druid = Druid.new(@druid) unless @druid.class == Druid
      @path  = File.join @root_dir, @druid.tree
    end

  end
  
end

