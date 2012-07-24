require 'rest_client'

module Dor::Assembly
  module Accessionable
    
    include Dor::Assembly::ContentMetadata

    def initiate_accessioning
      initialize_workspace
      initialize_apo_workflow
    end
    
    def initialize_workspace
      url         = "#{Dor::Config.dor.service_root}/dor/v1/objects/druid:#{@druid.id}/initialize_workspace"
      RestClient.post url, :source => parent_druid_tree_path
    end
    
    def initialize_apo_workflow
      url = "#{Dor::Config.dor.service_root}/dor/v1/objects/druid:#{@druid.id}/apo_workflows/accessionWF"
      RestClient.post url, {}       
    end
    
  end
end
