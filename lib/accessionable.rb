require 'rest_client'

module Dor::Assembly
  module Accessionable
    
    include Dor::Assembly::ContentMetadata

    def initiate_accessioning
      
      source_path=@druid.path(Dor::Config.assembly.root_dir)
      RestClient.post "#{Dor::Config.dor.service_root}/dor/v1/objects/druid:#{@druid.id}/initialize_workspace",:source=>source_path
#      obj.initialize_workspace  Dor::Config.assembly.root_dir
      RestClient.post "#{Dor::Config.dor.service_root}/dor/v1/objects/druid:#{@druid.id}/accession",{} 
#      obj.initiate_apo_workflow Dor::Config.assembly.next_workflow
    end

  end
end
