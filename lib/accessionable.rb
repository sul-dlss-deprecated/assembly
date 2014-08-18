require 'rest_client'

module Dor::Assembly
  module Accessionable

    include Dor::Assembly::ContentMetadata

    def initiate_accessioning
      Robots::DorRepo::Assembly::AccessioningInitiate.logger.warn("Inititate accessiong for #{@druid.id}")
      initialize_workspace
      initialize_apo_workflow
    end

    def initialize_workspace
      url         = "#{Dor::Config.dor.service_root}/objects/druid:#{@druid.id}/initialize_workspace"
      resp=RestClient.post url, :source => path_to_object
      Robots::DorRepo::Assembly::AccessioningInitiate.logger.warn("REST call to #{url} with response #{resp.code}")
    end

    def initialize_apo_workflow
      url         = "#{Dor::Config.dor.service_root}/objects/druid:#{@druid.id}/apo_workflows/accessionWF"
      resp=RestClient.post url, {}
      Robots::DorRepo::Assembly::AccessioningInitiate.logger.warn("REST call to #{url} with response #{resp.code}")
    end

  end
end
