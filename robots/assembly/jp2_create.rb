module Assembly
  
  class Jp2Create < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'jp2-create', opts)
    end
    
    def process_item(work_item)
      ai = Dor::Assembly::Item.new :druid => work_item.druid
      if (Dor::Config.configure.assembly.items_only && !ai.is_item?) 
        Assembly::Jp2Create.logger.warn("Skipping JP2-create for #{work_item.druid} since it is not an item")
      else
        ai.load_content_metadata
        ai.create_jp2s      
      end
    end

  end

end
