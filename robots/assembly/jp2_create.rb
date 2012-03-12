module Assembly
  
  class Jp2Create < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'jp2-create', opts)
    end

    def process_item(work_item)
      @ai = Dor::Assembly::Item.new :druid => work_item.druid
      @ai.create_jp2s
    end

  end

end
