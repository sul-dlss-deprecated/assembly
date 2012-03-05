module Dor
  module Checksumable
    
    def compute_checksums
      cs_tool = Checksum::Tools.new({}, *@checksum_types)
      file_nodes.each do |n|
        checksums = cs_tool.digest_file(file_path_of_node n)
        add_checksums_to_node n, checksums
      end
      persist_content_metadata
    end

    def add_checksums_to_node(node, checksums)
      checksums.each do |csum_type, csum_val|
        cn         = new_node 'checksum'
        cn.content = csum_val
        cn['type'] = csum_type.to_s
        node.add_child cn
      end
    end

  end
end

