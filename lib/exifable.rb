module Dor::Assembly
  module Exifable
    
    include Dor::Assembly::ContentMetadata

    ATTR_XML = '<attr name="representation">uncropped</attr>'

    def collect_exif_info
      relevant_fnode_image_tuples(:tif, :jpg, :jp2).each do |fn, img|
        exif=img.exif
        set_node_type_as_image fn.parent
        add_image_data_to_file_node fn,exif
        fn.add_child image_data_xml(exif)
        fn.add_child ATTR_XML
      end
      set_node_type_as_image @cm.root

      # Save the modified XML.
      persist_content_metadata
    end

    def set_node_type_as_image(node)
      node['type'] = 'image'
    end

    def add_image_data_to_file_node(node,exif)
      node['mimeType']=exif.mimetype
      node['format']=FORMATS[exif.mimetype]
      node['size']=exif.filesize.to_i.to_s
      #TODO this is probably where we should add the preserve/publish/shelve attributes from a config file
    end
    
    def image_data_xml(exif)
      w = exif.image_width
      h = exif.image_height
      %Q(<imageData width="#{w}" height="#{h}"/>)
    end

  end
end
