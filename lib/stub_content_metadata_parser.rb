# methods to help parse the stub content metadata file
module StubContentMetadataParser
  # this maps types coming from the stub content metadata (e.g. as produced by goobi) into the contentMetadata types allowed by the Assembly::Objectfile gem for CM generation
  def gem_content_metadata_style
    if stub_object_type.include?('book')
      :simple_book
    elsif stub_object_type.include?('map')
      :map
    elsif stub_object_type.casecmp('3d').zero? # just in case it comes in as 3D...
      :"3d"
    elsif stub_object_type == 'image'
      :simple_image
    else
      :file # the default content metadata style if not found via the mapping is :file
    end
  end

  def stub_object_type
    node = @stub_cm.xpath('/content/@type')
    node.empty? ? nil : node.first.value.downcase.strip
  end

  def resources
    @stub_cm.xpath('//resource')
  end

  def resource_label(resource)
    node = resource.css('/label')
    node.empty? ? '' : node.first.content
  end

  def resource_files(resource)
    resource.css('/file')
  end

  def filename(file)
    file.at_xpath('@name').value
  end

  def file_attributes(file)
    result = {}
    result[:preserve] = file.at_xpath('@preserve').value unless file.at_xpath('@preserve').blank?
    result[:publish] = file.at_xpath('@publish').value unless file.at_xpath('@publish').blank?
    result[:shelve] = file.at_xpath('@shelve').value unless file.at_xpath('@shelve').blank?
    result.empty? ? nil : result # return nil if no attributes are found; else return the hash
  end
end
