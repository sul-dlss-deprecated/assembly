module Dor::Assembly
  module ChecksumComparable
    
    include Dor::Assembly::ContentMetadata

    def compare_checksums
      # Compares <provider_checksum> against <checksum>.
      # Raises an exception if they disagree.
      # Returns the N of comparisons that matched.
      n_matches = 0

      file_nodes.each do |fn|
        fn.xpath('./provider_checksum').each do |provider_cs|

          # Get calculated checksum corresponding to the type of the provider checksum.
          cs_type = provider_cs['type']
          calc_cs = fn.xpath("./checksum[@type='#{cs_type}']").first

          # Do nothing if there is no calculated checksum.
          next if calc_cs.nil?  

          # Tally the match or fail.
          if provider_cs.content == calc_cs.content
            n_matches += 1
          else
            msg = %Q<Checksums disagree: type="#{cs_type}", file="#{fn['id']}".>
            raise StandardError, msg
          end

        end
      end

      return n_matches
    end

  end
end

