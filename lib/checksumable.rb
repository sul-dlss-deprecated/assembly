module Dor::Assembly
  module Checksumable
    
    include Dor::Assembly::ContentMetadata

    def compute_checksums
      # TODO: compute_checksums(): need to be able to handle TIF vs JP2.
      cs_types = [:md5, :sha1]
      cs_tool  = Checksum::Tools.new({}, *cs_types)
      file_nodes.each do |fn|
        remove_checksum_nodes fn
        f = File.join druid_tree_path, fn['id']
        add_checksum_nodes fn, cs_tool.digest_file(f)
      end

      persist_content_metadata
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

