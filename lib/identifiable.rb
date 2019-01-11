module Dor
  module Assembly
    module Identifiable
      def object_type
        obj_type = object.identityMetadata.objectType
        (obj_type.nil? ? 'unknown' : obj_type.first)
      end

      def is_item?
        object_type.downcase.strip == 'item'
      end
    end
  end
end
