module Dor::Assembly
  module Checksumable
    
    include Dor::Assembly::ContentMetadata
    include Dor::Assembly::Helper

    def compute_checksums
      # TODO: compute_checksums: spec.
      # TODO: compute_checksums: need to handle TIF vs JP2.
      # TODO: compute_checksums: activate persist_content_metadata.
      cs_tool = Checksum::Tools.new({}, *@checksum_types)
      file_nodes.each do |fn|
        remove_checksum_nodes fn
        checksums = cs_tool.digest_file(file_path_of_node fn)
        add_checksum_nodes fn, checksums
      end
      puts @cm
      # persist_content_metadata
    end

    def remove_checksum_nodes(parent_node)
      parent_node.xpath('checksum').each { |cn| cn.remove }
    end

    def add_checksum_nodes(parent_node, checksums)
      checksums.each do |typ, val|
        cn         = new_node_in_cm 'checksum'
        cn.content = val
        cn['type'] = typ.to_s
        parent_node.add_child cn
      end
    end

  end
end

