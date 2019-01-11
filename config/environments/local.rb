# frozen_string_literal: true

CERT_DIR = File.join(File.dirname(__FILE__), '..', 'certs')

Dor::Config.configure do
  fedora do
    url       'https://localhost/fedora'
  end

  ssl do
    cert_file File.join(CERT_DIR, 'local.crt')
    key_file  File.join(CERT_DIR, 'local.key')
    key_pass  ''
  end

  workflow.url 'https://localhost/workflow/'
  workflow.logfile 'log/workflow_service.log'
  workflow.shift_age 'weekly'

  robots do
    workspace '/tmp'
  end

  assembly do
    root_dir      ['spec/test_input', 'spec/test_input2'] # directories to search for content that should be acted upon by the robots
    cm_file_name  'contentMetadata.xml' # the name of the contentMetadata file
    stub_cm_file_name 'stubContentMetadata.xml' # the name of the stub contentMetadata file
    dm_file_name  'descMetadata.xml' # the name of the descMetadata file
    next_workflow 'accessionWF' # name of the next workflow to start after assembly robots are done
    overwrite_jp2     false # indicates if the jp2-create robot should overwrite an existing jp2 of the same name as the new one being created
    overwrite_dpg_jp2 false # indicates if the jp2-create robot should create a jp2 when there is a corresponding DPG style jp2
    # (e.g. oo000oo0001_00_001.tif and oo000oo0001_05_001.jp2, then a "false" setting here would NOT generate a new jp2 even though there is no filename clash)
    robot_sleep_time 30 # how long robots will sleep before attemping to connect to workflow service again
    tmp_folder '/tmp' # tmp file location for jp2-create and imagemagick
  end

  dor do
    service_root 'https://localhost/dor/v1'
  end

  stacks do
    document_cache_storage_root '/purl/document_cache'
    document_cache_host 'localhost'
    document_cache_user 'user'
    local_workspace_root '/dor/workspace'
    storage_root '/stacks'
    host 'localhost'
    user 'user'
  end
end

REDIS_URL ||= "localhost:6379/resque:#{ENV['ROBOT_ENVIRONMENT']}"
