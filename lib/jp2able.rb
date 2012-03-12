module Dor::Assembly
  module Jp2able
    
    include Dor::Assembly::ContentMetadata

    def create_jp2s
      # Process each <file> node in the content metadata.
      file_nodes.each do |fn|
        add_jp2_file_node fn, {}
      end

      # TODO: uncomment.
      # Save the modified XML.
      # persist_content_metadata
    end

    def add_jp2_file_node(parent_node, file_name)
      # Adds a file node representing the new jp2 file.
      fn            = new_node_in_cm 'file'
      fn[:preserve] = 'yes'
      fn[:publish]  = 'no'
      fn[:shelve]   = 'no'
      fn[:id]       = file_name
      parent_node.add_child fn
    end

  end
end

