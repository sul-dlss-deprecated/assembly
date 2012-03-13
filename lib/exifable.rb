module Dor::Assembly
  module Exifable
    
    include Dor::Assembly::ContentMetadata

    ATTR_XML = '<attr name="representation">uncropped</attr>'

    def collect_exif_info
      relevant_fnode_image_tuples(:tif, :jpg, :jp2).each do |fn, img|
        set_node_type_as_image fn.parent
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

    def image_data_xml(exif)
      w = exif.image_width
      h = exif.image_height
      %Q(<imageData width="#{w}" height="#{h}"/>)
    end

  end
end
