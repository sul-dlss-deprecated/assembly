module Dor
  module Checksumable
    
    def compute_checksums
      cs_tool    = Checksum::Tools.new({}, *@checksums.keys)
      @checksums = cs_tool.digest_file(@path)
    end

  end
end

