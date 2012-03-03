module Dor
  module Checksumable
    
    def compute_checksums
      # TODO: compute_checksums: need to store checksums in better data structure.
      # TODO: compute_checksums: persist checksums.
      cs_tool    = Checksum::Tools.new({}, *@checksum_types)
      @checksums = @files.map { |f| cs_tool.digest_file f }
    end

  end
end

