module Dor::Assembly
  module ChecksumComparable
    
    include Dor::Assembly::ContentMetadata

    def compare_checksums
      n_successes = 0

      file_nodes.each do |fn|
        fn.xpath('./provider_checksum').each { |provider_cs|
          cs_type = provider_cs['type']
          calc_cs = fn.xpath("./checksum[@type='#{cs_type}']").first

          # Bail if there is no calculated checksum.
          next if calc_cs.nil?

          unless provider_cs.content == calc_cs.content
            msg = "Calculated checksum disagrees with provider checksum (type=#{cs_type})."
            raise StandardError, msg
          end

          n_successes += 1
        }
      end

      return n_successes
    end

  end
end

