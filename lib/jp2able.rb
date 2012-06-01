module Dor::Assembly
  module Jp2able
    
    include Dor::Assembly::ContentMetadata

    def create_jp2s
      # For each supported image type that is part of specific resource types, generate a jp2 derivative
      # and modify content metadata XML to reflect the new file.
      jp2able_fnode_tuples=[]
      # grab all the file node tuples for each valid resource type that we want to generate derivates for
      Dor::Config.assembly.jp2_resource_types.each {|resource_type| jp2able_fnode_tuples += fnode_tuples(resource_type)}
            
      jp2able_fnode_tuples.each do |fn, obj|
        if obj.jp2able?
          img=Assembly::Image.new(obj.path) # create a new image object from the object file so we can generate a jp2
          # try to create the jp2
          begin
            jp2       = img.create_jp2
            file_name = fn['id'].gsub(File.basename(img.path),File.basename(jp2.path)) # generate new filename for jp2 file node in content metadata by replacing filename in base file node with new jp2 filenameis incoming file 
            add_jp2_file_node fn.parent, file_name
          rescue SecurityError
            # if we get a security exception, this means we have an existing jp2 -- don't fail, but do log it
            message="WARNING: Did not create jp2 for #{img.path} -- file already exists" 
            Assembly::Jp2Create.logger.warn(message)
          end
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
