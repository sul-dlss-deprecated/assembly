module Dor::Assembly
  module Exifable
    
    include Dor::Assembly::ContentMetadata

    def collect_exif_info

      # for fn,img in node-images
      #   next unless [fn,img] is relevant (tiff, jpeg, jp2)
      #   e = img.exif
      #   modify_cm(fn,e) 

      # For each supported image type, generate a jp2 derivative
      # and modify content metadata XML to reflect the new file.
      # relevant_images.each do |fn, img|
      #   jp2       = img.create_jp2
      #   file_name = File.basename jp2.path
      #   add_jp2_file_node fn.parent, file_name
      # end

      # Save the modified XML.
      # persist_content_metadata
    end

    # def all_images
    #   # Returns a list of node-Image pairs.
    #   file_nodes.map { |fn| [ fn, Assembly::Image.new(path_to_file fn['id']) ] }
    # end

    # def relevant_images
    #   # Returns a list of node-Image pairs,  after filtering out unsupported types.
    #   approved = ['image/tiff', 'image/jpeg']
    #   all_images.select { |fn, img| approved.include? img.exif.mimeType }
    # end

    # def add_jp2_file_node(parent_node, file_name)
    #   # Adds a file node representing the new jp2 file.
    #   f = %Q(<file preserve="yes" publish="no" shelve="no" id="#{file_name}" />)
    #   parent_node.add_child f
    # end

    # <contentMetadata type="image">
    #   <resource type="image">
    #     <file mimetype="image/tiff">
    #       <imageData width="100" height="100"/>
    #       <attr name="representation">uncropped</attr>
    #     </file>
    #     <file mimetype="image/jp2">
    #       <imageData width="100" height="100"/>
    #       <attr name="representation">uncropped</attr>
    #     </file>
    #   </resource>
    #   <resource type="image">
    #     <file mimetype="image/tiff">
    #       <imageData width="100" height="100"/>
    #       <attr name="representation">uncropped</attr>
    #     </file>
    #     <file mimetype="image/jp2">
    #       <imageData width="100" height="100"/>
    #       <attr name="representation">uncropped</attr>
    #     </file>
    #   </resource>
    # </contentMetadata>

  end
end
