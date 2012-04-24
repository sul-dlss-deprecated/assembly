module Dor::Assembly
  module Jp2able
    
    include Dor::Assembly::ContentMetadata

    def create_jp2s
      # For each supported image type, generate a jp2 derivative
      # and modify content metadata XML to reflect the new file.
      fnode_tuples.each do |fn, obj|
        if obj.jp2able?
          img=Assembly::Image.new(obj.path) # create a new image object from the object file so we can generate a jp2
          jp2       = img.create_jp2
          file_name = fn['id'].gsub(File.basename(img.path),File.basename(jp2.path)) # generate new filename for jp2 file node in content metadata by replacing filename in base file node with new jp2 filenameis incoming file 
          add_jp2_file_node fn.parent, file_name
        end
      end

      # Save the modified XML.
      persist_content_metadata
    end

    def add_jp2_file_node(parent_node, file_name)
      # Adds a file node representing the new jp2 file.
      f = %Q(<file id="#{file_name}" />)
      parent_node.add_child f
    end

  end
end
