# methods to help parse the stub content metadata file
module StubContentMetadataParser
  
  def stub_object_type
    node = @stub_cm.xpath('/content/@type')
    node.empty? ? nil : node.first.value
  end
  
  def stub_resources
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
  
  def directives(file)
    result = {}
    result[:preserve] = file.at_xpath('@preserve').value unless file.at_xpath('@preserve').blank? 
    result[:publish] = file.at_xpath('@publish').value unless file.at_xpath('@publish').blank? 
    result[:shelve] = file.at_xpath('@shelve').value unless file.at_xpath('@shelve').blank? 
    result
  end
  
end