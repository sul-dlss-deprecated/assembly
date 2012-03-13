module Dor::Assembly
  module Jp2able
    
    include Dor::Assembly::ContentMetadata

    def create_jp2s(params = {})
      # TODO: uncomment the persist call.
      relevant_images.each do |img|
        jp2 = img.create_jp2
        add_jp2_file_node fn, jp2.path
      end
      # persist_content_metadata
    end

    def relevant_images
      approved = ['image/tiff', 'image/jpeg']
      all_images.select { |img| approved.include? img.mimeType }
    end

    def all_images(fn)
      file_nodes.map { |fn| Assembly::Image.new(path_to_file fn['id']) }
    end

    def add_jp2_file_node(parent_node, file_name)
      # Adds a file node representing the new jp2 file.
      f = %Q(<file preserve="yes" publish="no" shelve="no" id="#{file_name}" />)
      parent_node.add_child f
    end

  end
end

