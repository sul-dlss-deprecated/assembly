CERT_DIR = File.join(File.dirname(__FILE__), "..", "certs")

Dor::Config.configure do

  fedora do
    url       'https://USERNAME:PASSWORD@dor-dev.stanford.edu/fedora'
  end

  ssl do
    cert_file File.join(CERT_DIR, "dlss-dev-test.crt")
    key_file  File.join(CERT_DIR, "dlss-dev-test.key")
    key_pass  ''
  end
  
  workflow.url 'https://lyberservices-dev.stanford.edu/workflow/'

  robots do 
    workspace '/tmp'
  end

  assembly do
    root_dir      ['spec/test_input','spec/test_input2']
    cm_file_name  'contentMetadata.xml'
    dm_file_name  'descMetadata.xml'
    next_workflow 'accessionWF'
  end

  dor do
    service_root 'https://USERNAME:PASSWORD@lyberservices-dev.stanford.edu'
  end

end
