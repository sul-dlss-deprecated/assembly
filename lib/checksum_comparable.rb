module Dor::Assembly
  module ChecksumComparable
    
    include Dor::Assembly::ContentMetadata

    def compare_checksums

      # cs_types = [:md5, :sha1]
      # cs_tool  = Checksum::Tools.new({}, *cs_types)
      # file_nodes.each do |fn|
      #   remove_checksum_nodes fn
      #   f = File.join druid_tree_path, fn['id']
      #   add_checksum_nodes fn, cs_tool.digest_file(f)
      # end

      # persist_content_metadata
    end

  end
end

