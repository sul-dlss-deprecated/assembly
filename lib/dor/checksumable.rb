module Dor
  module Checksumable
    # extend ActiveSupport::Concern
    # include Itemizable
    
    def checksum
      puts "checksum"
      # files = [] # doc.xpath("//file").select {|f| f['shelve'] == 'yes'}.map{|f| f['id']}
      # self.datastreams['contentMetadata'].ng_xml.xpath('//file').each do |file|
      #   files << file['id'] if(file['shelve'].downcase == 'yes')
      # end
      # 
      # DigitalStacksService.shelve_to_stacks(pid, files)
    end

  end
end

