module Dor::Assembly
  module ContentMetadata

    attr_accessor(
      :cm,
      :cm_file_name,
      :cm_handle,
      :druid,
      :root_dir
    )

  # used to identify the content type in the content meta-data file, it maps mime/types to format attribute values in the content metadata XML file
  # see https://consul.stanford.edu/display/chimera/DOR+file+types+and+attribute+values 
    FORMATS={
      'image/jp2'=>'JPEG2000','image/jpeg'=>'JPEG','image/tiff'=>'TIFF','image/tiff-fx'=>'TIFF','image/ief'=>'TIFF','image/gif'=>'GIF',
      'text/plain'=>'TEXT','text/html'=>'HTML','text/csv'=>'CSV','audio/x-aiff'=>'AIFF','audio/x-mpeg'=>'MP3','audio/x-wave'=>'WAV',
      'video/mpeg'=>'MP2','video/quicktime'=>'QUICKTIME','video/x-msvideo'=>'AVI','application/pdf'=>'PDF','application/zip'=>'ZIP','application/xml'=>'XML',
      'application/tei+xml'=>'TEI','application/msword'=>'WORD','application/wordperfect'=>'WPD','application/mspowerpoint'=>'PPT','application/msexcel'=>'XLS',
      'application/x-tar'=>'TAR','application/octet-stream'=>'BINARY'
        }
        
    FILE_TYPES=FORMATS.invert

    def load_content_metadata
      # Loads content metadata XML into a Nokogiri document.
      @cm = Nokogiri.XML(File.open @cm_file_name) { |conf| conf.default_xml.noblanks }
    end

    def persist_content_metadata
      # Writes content metadata XML to the content metadata file or
      # to @cm_handle (the latter is used for testing purposes).
      xml = @cm.to_xml
      if @cm_handle
        @cm_handle.puts xml
      else
        File.open(@cm_file_name, 'w') { |f| f.puts xml }
      end
    end

    def new_node_in_cm(node_name)
      # Returns a new node with the supplied name (with the GC lifecycle of
      # the content metadata document).
      Nokogiri::XML::Node.new node_name, @cm
    end

    def druid_tree_path
      File.join @root_dir, @druid.path
    end

    def path_to_file(file_name)
      File.join druid_tree_path, file_name
    end

    def file_nodes
      # Returns all Nokogiri <file> nodes from content metadata.
      @cm.xpath '//resource/file'
    end

    def fnode_tuples
      # Returns a list of filenode-Image pairs.
      file_nodes.map { |fn| [ fn, Assembly::Image.new(path_to_file fn['id']) ] }
    end

    def relevant_fnode_tuples(*wanted)
      # Returns a list of node-Image pairs,  after filtering out unwanted types.
      # Caller supplies a list of ke
      relevant = wanted.map { |t| 
        mime_type = FILE_TYPES[t]
        raise ArgumentError, "Invalid file type: #{t}." if mime_type.nil?
        mime_type
      }
      fnode_tuples.select { |fn, file| relevant.include? file.exif.mimeType }
    end

  end
end

