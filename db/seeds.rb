# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def import_test_data path
  count=0
  file_name_list=[]
  Dir.foreach(path) do |file|
  file_name_list << file
  end
 
  File.open "#{path}/#{file_name_list[2]}" do |file|
  xml_str=''   
 file.each_line do |line|
 xml_str = xml_str+line
end

xml_doc  = Nokogiri::XML(xml_str)
puts xml_str
binding.pry
xml_doc.xpath('//dc:creator').text
end
end

import_test_data "/hd/metadata/data/guji"

