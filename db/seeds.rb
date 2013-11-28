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
      parsed_date = ''
      begin
        parsed_date = Date.parse(xml_doc.xpath('//dc:date').text) unless xml_doc.xpath('//dc:date').text==''
      rescue
        puts xml_doc.xpath('//dc:date').text
      end
      if parsed_date.length!=0
        body_json = {
            "title" => xml_doc.xpath('//dc:title').text,
            "creator" => xml_doc.xpath('//dc:creator').text,
            "subject" => xml_doc.xpath('//dc:subject').text,
            "descripton" => xml_doc.xpath('//dc:descripton').text,
            "publisher" => xml_doc.xpath('//dc:publisher').text,
            "contributor" => xml_doc.xpath('//dc:contributor').text,
            "date" => xml_doc.xpath('//dc:date').text,
            "type" => xml_doc.xpath('//dc:type').text,
            "format" => xml_doc.xpath('//dc:format').text,
            "identifier" => xml_doc.xpath('//dc:identifier').text,
            "source" => xml_doc.xpath('//dc:source').text,
            "language" => xml_doc.xpath('//dc:language').text,
            "relation" => xml_doc.xpath('//dc:relation').text,
            "coverage" => xml_doc.xpath('//dc:coverage').text,
            "rights" => xml_doc.xpath('//dc:rights').text,
            "harvest_time" => Date.new
        }
      else
        body_json = {
            "title" => xml_doc.xpath('//dc:title').text,
            "creator" => xml_doc.xpath('//dc:creator').text,
            "subject" => xml_doc.xpath('//dc:subject').text,
            "descripton" => xml_doc.xpath('//dc:descripton').text,
            "publisher" => xml_doc.xpath('//dc:publisher').text,
            "contributor" => xml_doc.xpath('//dc:contributor').text,
            "type" => xml_doc.xpath('//dc:type').text,
            "format" => xml_doc.xpath('//dc:format').text,
            "identifier" => xml_doc.xpath('//dc:identifier').text,
            "source" => xml_doc.xpath('//dc:source').text,
            "language" => xml_doc.xpath('//dc:language').text,
            "relation" => xml_doc.xpath('//dc:relation').text,
            "coverage" => xml_doc.xpath('//dc:coverage').text,
            "rights" => xml_doc.xpath('//dc:rights').text,
            "harvest_time" => Date.new
        }
      end
      @client.index index: 'oai', type: 'item', body: body_json


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

import_test_data "/hd/metadata/data/guji"
#mapping

