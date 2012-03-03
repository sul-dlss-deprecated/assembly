module Dor
  module Checksumable
    
    def compute_checksums
      cs_tool    = Checksum::Tools.new({}, *@checksum_types)
      @checksums = {}
      @files.each { |f| @checksums[f] = cs_tool.digest_file(f) }
      persist_assembly_info :checksums
    end

  end
end

