module Dor
  module Checksumable
    
    def compute_checksums
      # TODO: compute_checksums: need to store checksums in better data structure.
      cs_tool    = Checksum::Tools.new({}, *@checksums.keys)
      @checksums = @files.each { |f| cs_tool.digest_file f }
    end

  end
end

