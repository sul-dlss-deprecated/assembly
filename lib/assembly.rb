# frozen_string_literal: true

require 'content_metadata'
require 'jp2able'
require 'checksumable'
require 'findable'
require 'identifiable'
require 'item'

Dor::Config.configure do
  assembly do
    jp2_resource_types  %w[page image] # only file nodes in resources of this 'type' will have jp2 derivatives made, and only if valid image mimetypes as defined by assembly-objectfile gem
    items_only          true           # exif-collect, checksum-compute and jp2aable only operate on dor type="item" if this is set to true
  end
end
