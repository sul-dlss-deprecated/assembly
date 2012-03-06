module Dor::Assembly
  module Helper

    # TODO: Helper: specs.

    def druid_tree_path
      File.join @root_dir, @druid.tree
    end

    def file_nodes
      @cm.xpath '//resource/file'
    end

  end
end
