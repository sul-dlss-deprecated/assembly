module Assembly
  
  class Checksum < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'checksum', opts)
    end

    def process_item(work_item)
      # obj = Dor::AssemblyItem.load(work_item.druid)
      # obj.checksum
      puts "hello world"
    end

  end

end
