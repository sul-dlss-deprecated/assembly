module Dor::Assembly
  module Exifable
    
    include Dor::Assembly::ContentMetadata

    def collect_exif_info
      #TODO this should operate on more than these specific content types, and be configurable to take the correct action based on type
      relevant_fnode_tuples('TIFF', 'JPEG', 'JPEG2000').each do |fn, img|
        set_node_type fn.parent,'image'
        add_data_to_file_node fn,img
        fn.add_child image_data_xml(img.exif)
      end
      set_node_type @cm.root,'image'

      # Save the modified XML.
      persist_content_metadata
    end

    def set_node_type(node,node_type,overwrite=false)
      node['type'] = node_type if (node['type'].blank? || overwrite) # only set the node if it's not empty, unless we allow overwrite
    end

    def add_data_to_file_node(node,file)
      node['mimeType']=file.exif.mimetype
      node['format']=FORMATS[file.exif.mimetype]
      node['size']=file.filesize.to_s
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
