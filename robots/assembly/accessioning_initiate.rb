require_relative './base'

module Robots
  module DorRepo
    module Assembly
      class AccessioningInitiate < Robots::DorRepo::Assembly::Base
        def initialize(opts = {})
          super('dor', 'assemblyWF', 'accessioning-initiate', opts)
        end

        def perform(druid)
          @ai = item(druid)
          LyberCore::Log.info("Inititate accessioning for #{@ai.druid.id}")
          initialize_workspace if @ai.is_item?
          initialize_workflow
          true
        end

        private

        def initialize_workspace
          url = "#{Dor::Config.dor.service_root}/objects/druid:#{@ai.druid.id}/initialize_workspace"
          resp = RestClient.post url, source: @ai.path_to_object
          LyberCore::Log.info("REST call to #{url} with response #{resp.code}")
        end

        def initialize_workflow
          url = "#{Dor::Config.dor.service_root}/objects/druid:#{@ai.druid.id}/apo_workflows/accessionWF"
          resp = RestClient.post url, {}
          LyberCore::Log.info("REST call to #{url} with response #{resp.code}")
        end
      end
    end
  end
end
