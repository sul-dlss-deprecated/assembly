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

    def add_jp2_file_node(parent_node, params)
      p parent_node
      # <file preserve="yes" publish="no" shelve="no" id="image111.tif" />
      #

      # checksums.each do |typ, val|
      #   cn         = new_node_in_cm 'checksum'
      #   cn.content = val
      #   cn['type'] = typ.to_s
      #   parent_node.add_child cn
      # end

    end

  end
end

