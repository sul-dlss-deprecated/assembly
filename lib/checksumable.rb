module Dor::Assembly
  module Checksumable
    
    # TODO: Checksmable: methods below need specs.
    # TODO: Checksmable: need to handle TIF vs JP2.

    def compute_checksums
      cs_tool = Checksum::Tools.new({}, *@checksum_types)
      file_nodes.each do |n|
        remove_checksum_child_nodes n
        checksums = cs_tool.digest_file(file_path_of_node n)
        add_checksum_child_nodes n, checksums
      end
      persist_content_metadata
    end

    def remove_checksum_child_nodes(parent_node)
      parent_node.css('checksum').each { |cn| cn.remove }
    end

    def add_checksum_child_nodes(parent_node, checksums)
      checksums.each do |typ, val|
        cn         = new_node 'checksum'
        cn.content = val
        cn['type'] = typ.to_s
        parent_node.add_child cn
      end
    end

  end
end

