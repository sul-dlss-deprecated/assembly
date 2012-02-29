require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'assembly/checksum.rb'

describe Assembly::Checksum do
  
  it "is a LyberCore::Robots::Robot" do
    r = Assembly::Checksum.new
    r.should be_a_kind_of LyberCore::Robots::Robot 
    r.process_item('aa123bb1234')
  end
  
end
