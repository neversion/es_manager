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

    xml_doc = Nokogiri::XML(xml_str)
    binding.pry
    xml_doc.xpath('//dc:creator').text
  end
end

def mapping
  @client.indices.create index: 'oai',
                         body: {
                             settings: {
                                 index: {
                                     number_of_shards: 5,
                                     number_of_replicas: 1,
                                 }
                             },
                             mappings: {
                                 item: {
                                     properties: {
                                         title: {type: 'string', analyzer: 'snowball', store: 'yes', boost: 3.0},
                                         creator: {type: 'string', analyzer: 'snowball', store: 'yes'},
                                         subject: {type: 'string', analyzer: 'snowball',store: 'yes'},
                                         description: {type: 'string',analyzer: 'snowball', store: 'yes'},
                                         publisher: {type: 'string', store: 'yes'},
                                         contributor: {type: 'string', analyzer: 'snowball', store: 'yes'},
                                         date: {type: 'date', store: 'yes'},
                                         type: {type: 'string', analyzer: 'snowball', store: 'yes'},
                                         format: {type: 'string',index: 'not_analyzed', store: 'yes'},
                                         identifier: {type: 'string',index: 'not_analyzed', store: 'yes'},
                                         source: {type: 'string',index: 'not_analyzed', store: 'yes'},
                                         language: {type: 'string',index: 'not_analyzed', store: 'yes'},
                                         relation: {type: 'string', store: 'yes'},
                                         coverage: {type: 'string',index: 'no', store: 'yes'},
                                         rights: {type: 'string',index: 'not_analyzed', store: 'yes'},
                                         harvest_time: {type: 'date', store: 'yes'},
                                     }
                                 }
                             }
                         }

end

#import_test_data "/hd/metadata/data/guji"
mapping
