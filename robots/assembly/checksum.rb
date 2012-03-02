module Assembly
  
  class Checksum < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'checksum', opts)
    end

    def process_item(work_item)
      # @ai = Dor::AssemblyItem.load(work_item.druid)
      @ai = Dor::AssemblyItem.new :druid => 'aa111bb2222'
      @ai.checksum
      return true
    end

  end

end
