module Assembly
  
  class ChecksumCompare < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'checksum-compare', opts)
    end

    def process_item(work_item)
      @ai = Dor::Assembly::Item.new :druid => work_item.druid
      @ai.compare_checksums
    end

  end

end
