# monkey patch to fix SSL problem on sul-lyberservices-dev 
# TODO fix me so we don't need to monkey patch the dor services gem
module Dor
  module WorkflowService
    class << self
      def workflow_resource
        RestClient::Resource.new(Config.workflow.url,
        :ssl_client_cert  =>  OpenSSL::X509::Certificate.new(File.read(Config.fedora.cert_file)),
        :ssl_client_key   =>  OpenSSL::PKey::RSA.new(File.read(Config.fedora.key_file), Config.fedora.key_pass)),
        :verify_ssl => OpenSSL::SSL::VERIFY_NONE
      end
    end
  end
end

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
