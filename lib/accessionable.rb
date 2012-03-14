module Dor::Assembly
  module Accessionable
    
    include Dor::Assembly::ContentMetadata

    def initiate_accessioning
      obj = get_dor_object
      obj.initialize_workspace  Dor::Config.assembly.root_dir
      obj.initiate_apo_workflow Dor::Config.assembly.next_workflow
    end

    def get_dor_object
      Dor::Item.load_instance @druid.druid
    end

  end
end
