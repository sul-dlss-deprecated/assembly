module Assembly
  
  class Checksum < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'checksum', opts)
    end

    def process_item(work_item)
      # TODO: how will the work_item know root directory? ROBOT_ROOT???
      @ai = Dor::AssemblyItem.new :druid => 'aa111bb2222'
      @ai.checksum
      return true
    end

  end

end
