module Dor::Assembly
  module Findable

    # actual path to object, found by iterating through all possible root paths and looking first for the new druid tree path, then for the old druid path
    #  return nil if not found anywhere
    def path_to_object
      return @path_to_object unless @path_to_object.nil?
      path = nil
      Array(@root_dir).each do |root_dir|
        new_path=druid_tree_path(root_dir)
        old_path=old_druid_tree_path(root_dir)
        if File.directory? new_path
          path = new_path
          break
        elsif File.directory? old_path
          path = old_path
          break
        end
      end
      @path_to_object = path
    end

    # new style path, e.g. aa/111/bb/2222/aa111bb2222
    def druid_tree_path(root_dir)
      DruidTools::Druid.new(@druid.id, root_dir).path
    end

    # old style path, e.g. aa/111/bb/2222
    def old_druid_tree_path(root_dir)
      File.dirname druid_tree_path(root_dir)
    end

    # returns the location of a content file, which can be in the old location if not found in the new location, e.g.  aa/111/bb/2222/aa111bb2222/content or  aa/111/bb/2222/
    def content_file(filename)
      File.exists?(path_to_content_file(filename)) ? path_to_content_file(filename) : old_path_to_file(filename)
    end

    # returns the location of a metadata file, which can be in the old location if not found in the new location, e.g.  aa/111/bb/2222/aa111bb2222/metadata or  aa/111/bb/2222/
    def metadata_file(filename)
      File.exists?(path_to_metadata_file(filename)) ? path_to_metadata_file(filename) : old_path_to_file(filename)
    end

    # new style path to a content file, e.g.  aa/111/bb/2222/aa111bb2222/content
    def path_to_content_file(file_name)
      File.join path_to_object, "content", file_name
    end

    # new style path to a metadata file, e.g.  aa/111/bb/2222/aa111bb2222/metadata
    def path_to_metadata_file(file_name)
      File.join path_to_object, "metadata", file_name
    end

    # old style path to a file, without subfolder e.g.  aa/111/bb/2222/
    def old_path_to_file(file_name)
      File.join path_to_object, file_name
    end

  end
end
