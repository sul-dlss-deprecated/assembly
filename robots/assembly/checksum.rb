module Assembly
  
  class ChecksumCompute < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'checksum-compute', opts)
    end

    def process_item(work_item)
      @ai = Dor::Assembly::Item.new :druid => work_item.druid
      @ai.compute_checksums
    end

  end

end
