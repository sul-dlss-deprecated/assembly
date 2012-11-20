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
          
           # check to see if there is another JP2 that exists with the same DPG basename (e.g. if oo000oo0001_05_00.jp2 exists and you call create_jp2 for oo000oo0001_00_00.tif, you will not create a new JP2, even though there would not be a filename clash)
           if !Dor::Config.assembly.overwrite_dpg_jp2 && File.exists?(img.dpg_jp2_filename) # don't fail this case, but log it
             message="WARNING: Did not create jp2 for #{img.path} -- since another JP2 with the same DPG base name called #{img.dpg_jp2_filename} exists"
             Assembly::Jp2Create.logger.warn(message)
           elsif !Dor::Config.assembly.overwrite_jp2 && File.exists?(img.jp2_filename) # if we have an existing jp2 with the same basename as the tiff -- don't fail, but do log it
             message="WARNING: Did not create jp2 for #{img.path} -- file already exists" 
             Assembly::Jp2Create.logger.warn(message)            
           else
             jp2       = img.create_jp2(:overwrite=>Dor::Config.assembly.overwrite_jp2)
             file_name = fn['id'].gsub(File.basename(img.path),File.basename(jp2.path)) # generate new filename for jp2 file node in content metadata by replacing filename in base file node with new jp2 filename 
             add_jp2_file_node fn.parent, file_name
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
