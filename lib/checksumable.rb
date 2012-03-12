module Dor::Assembly
  module Checksumable
    
    include Dor::Assembly::ContentMetadata

    def compute_checksums
      # Get the object we'll use to compute checksums.
      cs_types = [:md5, :sha1]
      cs_tool  = Checksum::Tools.new({}, *cs_types)

      # Process each <file> node in the content metadata.
      file_nodes.each do |fn|
        # Compute checksums.
        file_path = File.join druid_tree_path, fn['id']
        checksums = cs_tool.digest_file(file_path)

        # Modify the content metadata XML.
        remove_checksum_nodes fn
        add_checksum_nodes fn, checksums
      end

      # Save the modified XML.
      persist_content_metadata
    end

    def remove_checksum_nodes(parent_node)
      # Removes any pre-existing checksum child nodes.
      parent_node.xpath('checksum').each { |cn| cn.remove }
    end

    def add_checksum_nodes(parent_node, checksums)
      # Checksum::Tools returns a hash like this:
      #     :md5  => CHECKSUM,
      #     :sha1 => CHECKSUM,
      # 
      # Iterate over that hash, adding checksum child nodes.
      checksums.each do |typ, val|
        cn         = new_node_in_cm 'checksum'
        cn.content = val
        cn['type'] = typ.to_s
        parent_node.add_child cn
      end
    end

  end
end

