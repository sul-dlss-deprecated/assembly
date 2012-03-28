module Dor::Assembly
  module Jp2able
    
    include Dor::Assembly::ContentMetadata

    def create_jp2s
      # For each supported image type, generate a jp2 derivative
      # and modify content metadata XML to reflect the new file.
      relevant_fnode_image_tuples(:tif, :jpg).each do |fn, img|
        jp2       = img.create_jp2
        file_name = File.basename jp2.path
        add_jp2_file_node fn.parent, file_name
      end

      # Save the modified XML.
      persist_content_metadata
    end

    def add_jp2_file_node(parent_node, file_name)
      # Adds a file node representing the new jp2 file.
      f = %Q(<file preserve="#{Dor::Config.assembly.preserve}" publish="#{Dor::Config.assembly.publish}" shelve="#{Dor::Config.assembly.shelve}" id="#{file_name}" />)
      parent_node.add_child f
    end

  end
end
