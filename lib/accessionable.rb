require 'rest_client'

module Dor::Assembly
  module Accessionable
    
    include Dor::Assembly::ContentMetadata

    def initiate_accessioning
      
      initialize_workspace
      initialize_apo_workflow
      
    end
    
    def initialize_workspace
      source_path=@druid.path(Dor::Config.assembly.root_dir)
      RestClient.post "#{Dor::Config.dor.service_root}/dor/v1/objects/druid:#{@druid.id}/initialize_workspace",:source=>source_path      
    end
    
    def initialize_apo_workflow
      RestClient.post "#{Dor::Config.dor.service_root}/dor/v1/objects/druid:#{@druid.id}/accession",{}       
    end
    
  end
end
