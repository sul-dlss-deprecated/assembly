module Assembly
  
  class Jp2Create < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'jp2-create', opts)
    end

    def assembly_item(druid=nil)
      @ai ||= Dor::Assembly::Item.new :druid => druid
    end
    
    def process_item(work_item)
      druid=work_item.druid
      if (Dor::Config.configure.assembly.items_only && !assembly_item(druid).is_item?) 
        Assembly::Jp2Create.logger.info("Skipping JP2-create for #{druid} since it is not an item")
      else
        assembly_item(druid).load_content_metadata
        assembly_item(druid).create_jp2s      
      end
    end

  end

end
