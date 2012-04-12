module Dor::Assembly
  module Exifable
    
    include Dor::Assembly::ContentMetadata

    def collect_exif_info
      fnode_tuples.each do |fn, obj|

        # always add certain attributes to file node regardless of type
        add_data_to_file_node fn,obj
        
        # now depending on the type of object in the file node (i.e. image vs pdf) add other attributes to content metadata
        case obj.object_type

          when :image # when the object type is an image
            set_node_type fn.parent,'image'  # set the resource type to 'image' if it's not currently defined
            fn.add_child image_data_xml(obj.exif)          
        end
      end
      
      # set the root contentMetadata type to 'image' if it's not currently defined
      set_node_type @cm.root,'image'

      # Save the modified XML.
      persist_content_metadata
      
    end

    def set_node_type(node,node_type,overwrite=false)
      node['type'] = node_type if (node['type'].blank? || overwrite) # only set the node if it's not empty, unless we allow overwrite
    end

    def add_data_to_file_node(node,file)
      node['mimeType']=file.mimetype
      node['format']=Assembly::FORMATS[file.mimetype] || ''
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
