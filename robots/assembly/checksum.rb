module Assembly
  
  class Checksum < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'checksum', opts)
    end

    def process_item(work_item)
      @ai = Dor::AssemblyItem.new(
        :druid    =>  work_item.druid,
        :root_dir => Dor::AssemblyItem::ASSEMBLY_ROOT
      )
      # TODO : process_item() : uncomment call to compute_checksums().
      # @ai.compute_checksums
      return true
    end

  end

end
