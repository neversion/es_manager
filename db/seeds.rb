def import_test_data path
  file_name_list=[]
  Dir.foreach(path) do |file|
    file_name_list << file
  end
  host = "http://210.34.4.113:9200"
  @client = Elasticsearch::Client.new host: host, log: true

  (2..file_name_list.count-1).each do |index|
    File.open "#{path}/#{file_name_list[index]}" do |file|
      xml_str=''
      file.each_line do |line|
        xml_str = xml_str+line
      end
      xml_doc = Nokogiri::XML(xml_str)
      binding.pry
      @client.index index: 'oai', type: 'item', body: {
          title : xml_doc.xpath('//dc:creator').text,
          creator : xml_doc.xpath('//dc:creator').text,
          subject : xml_doc.xpath('//dc:creator').text,
          descripton : xml_doc.xpath('//dc:creator').text,
          publisher : xml_doc.xpath('//dc:creator').text,
          contributor : xml_doc.xpath('//dc:creator').text,
          date : xml_doc.xpath('//dc:creator').text,
          type : xml_doc.xpath('//dc:creator').text,
          format : xml_doc.xpath('//dc:creator').text,
          identifier : xml_doc.xpath('//dc:creator').text,
          source : xml_doc.xpath('//dc:creator').text,
          language : xml_doc.xpath('//dc:creator').text,
          relation : xml_doc.xpath('//dc:creator').text,
          coverage : xml_doc.xpath('//dc:creator').text,
          rights : xml_doc.xpath('//dc:creator').text,
          harvest_time : xml_doc.xpath('//dc:creator').text
      }


    end
  end

end




def mapping
  host = "http://210.34.4.113:9200"
  @client = Elasticsearch::Client.new host: host, log: true
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
                                         subject: {type: 'string', analyzer: 'snowball', store: 'yes'},
                                         description: {type: 'string', analyzer: 'snowball', store: 'yes'},
                                         publisher: {type: 'string', store: 'yes'},
                                         contributor: {type: 'string', analyzer: 'snowball', store: 'yes'},
                                         date: {type: 'date', store: 'yes'},
                                         type: {type: 'string', analyzer: 'snowball', store: 'yes'},
                                         format: {type: 'string', index: 'not_analyzed', store: 'yes'},
                                         identifier: {type: 'string', index: 'not_analyzed', store: 'yes'},
                                         source: {type: 'string', index: 'not_analyzed', store: 'yes'},
                                         language: {type: 'string', index: 'not_analyzed', store: 'yes'},
                                         relation: {type: 'string', store: 'yes'},
                                         coverage: {type: 'string', index: 'no', store: 'yes'},
                                         rights: {type: 'string', index: 'not_analyzed', store: 'yes'},
                                         harvest_time: {type: 'date', store: 'yes'},
                                     }
                                 }
                             }
                         }

end

#import_test_data "/hd/metadata/data/guji"
mapping
