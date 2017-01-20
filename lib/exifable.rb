module Dor::Assembly
  module Exifable

    include Dor::Assembly::ContentMetadata

    def collect_exif_info

      LyberCore::Log.info("Collecting exif info for #{druid.id}")

      fnode_tuples.each do |fn, obj|

        # always add certain attributes to file node regardless of type
        add_data_to_file_node fn,obj

        # now depending on the type of object in the file node (i.e. image vs pdf) add other attributes to resource content metadata
        case obj.object_type

          when :image # when the object file type is an image
            fn.add_child(image_data_xml(obj.exif)) if fn.css('imageData').empty?

          else #all other object file types will force resource type to not be an image
            set_node_type fn.parent,'file' # set the resource type to 'file' if it's not currently defined

          end
      end

      # set the root contentMetadata type to default to 'image' if it's not currently defined
      set_node_type @cm.root,'image'

      # Save the modified XML.
      persist_content_metadata

    end

    def set_node_type(node,node_type,overwrite=false)
      node['type'] = node_type if (node['type'].blank? || overwrite) # only set the node if it's not empty, unless we allow overwrite
    end

    def add_data_to_file_node(node,file)

      node['mimetype']=file.mimetype unless node['mimetype']
      node['size']=file.filesize.to_s unless node['size']

      # add publish/preserve/shelve attributes based on mimetype, unless they already exist in content metadata (use defaults if mimetype not found in mapping)
      file_attributes=Assembly::FILE_ATTRIBUTES[file.mimetype] || Assembly::FILE_ATTRIBUTES['default']

      node['preserve']=file_attributes[:preserve] unless node['preserve']
      node['publish']=file_attributes[:publish] unless node['publish']
      node['shelve']=file_attributes[:shelve] unless node['shelve']

    end

    def image_data_xml(exif)
      w = exif.image_width
      h = exif.image_height
      %Q(<imageData width="#{w}" height="#{h}"/>)
    end

  end
end
