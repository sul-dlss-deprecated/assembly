module Dor::Assembly
  module Jp2able
    
    include Dor::Assembly::ContentMetadata

    def create_jp2s(params = {})
      # Process each <file> node in the content metadata.
      n_created = 0

      file_nodes.each do |fn|
        file_path = File.join druid_tree_path, fn['id']
        img = Assembly::Image.new file_path
        next unless img.mimeType == "image/tiff"

        jp2 = img.create_jp2 params
        add_jp2_file_node fn, jp2.path
         
        n_created += 1
      end

      return n_created

      # TODO: uncomment.
      # Save the modified XML.
      # persist_content_metadata
    end

    def add_jp2_file_node(parent_node, file_name)
      # Adds a file node representing the new jp2 file.
      f = %Q(<file preserve="yes" publish="no" shelve="no" id="#{file_name}" />)
      parent_node.add_child f
    end

  end
end

