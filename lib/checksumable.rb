module Dor::Assembly
  module Checksumable
    
    include Dor::Assembly::ContentMetadata

    def compute_checksums
      # Get the object we'll use to compute checksums.

      # Process each <file> node in the content metadata.
      file_nodes.each do |fn|
        # Compute checksums.
        obj=Assembly::ObjectFile.new(path_to_file fn['id'])
        
        # compute checksums
        checksums={:md5=>obj.md5,:sha1=>obj.sha1}

        # find any existing checksum nodes
        md5_nodes=fn.xpath('checksum[@type="md5"]')
        sha1_nodes=fn.xpath('checksum[@type="sha1"]')
        
        # if we have any existing checksum nodes, compare them all against the checksums we just computed, and raise an error if any fail
        raise %Q<Checksums disagree: type="md5", file="#{fn['id']}".> unless checksums_equal?(md5_nodes,checksums[:md5])
        raise %Q<Checksums disagree: type="sha1", file="#{fn['id']}".> unless checksums_equal?(sha1_nodes,checksums[:sha1])
        
        # Modify the content metadata XML to add the checksums if they do not exist        
        add_checksum_node fn, 'md5',checksums[:md5] if md5_nodes.size == 0
        add_checksum_node fn, 'sha1',checksums[:sha1] if sha1_nodes.size == 0
        
      end

      # Save the modified XML.
      persist_content_metadata
      
    end

    # compare existing checksum nodes with computed checksum, return false if there are any mismatches, otherwise return true
    def checksums_equal?(existing_checksum_nodes,computed_checksum)
      
      match=true
      existing_checksum_nodes.each {|checksum| match = false if checksum.content != computed_checksum}
      return match
      
    end
    
    def add_checksum_node(parent_node, checksum_type,checksum)
      cn         = new_node_in_cm 'checksum'
      cn.content = checksum
      cn['type'] = checksum_type
      parent_node.add_child cn
    end

  end
end

