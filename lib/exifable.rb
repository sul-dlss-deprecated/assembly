module Dor::Assembly
  module Exifable
    
    include Dor::Assembly::ContentMetadata

    #TODO can we just take this off?
    ATTR_XML = '<attr name="representation">uncropped</attr>'

    def collect_exif_info
      #TODO this should operate on more than these specific content types, and be configurable to take the correct action based on type
      relevant_fnode_image_tuples(:tif, :jpg, :jp2).each do |fn, img|
        set_node_type_as_image fn.parent
        add_image_data_to_file_node fn,img
        fn.add_child image_data_xml(img.exif)
        fn.add_child ATTR_XML
      end
      set_node_type_as_image @cm.root

      # Save the modified XML.
      persist_content_metadata
    end

    def set_node_type_as_image(node)
      node['type'] = 'image'
    end

    def add_image_data_to_file_node(node,img)
      node['mimeType']=img.exif.mimetype
      node['format']=FORMATS[img.exif.mimetype]
      node['size']=img.filesize.to_s
      # TODO if we need to override for a given content type and for a given object, this is probably where we should add/edit the preserve/publish/shelve attributes from a config file, 
      # right now they are added in jp2able in the 'add_jp2_file_node' method
    end
    
    def image_data_xml(exif)
      w = exif.image_width
      h = exif.image_height
      %Q(<imageData width="#{w}" height="#{h}"/>)
    end

  end
end
