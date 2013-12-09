def create_index_mapping index_name
  host = "http://210.34.4.113:9200"
  @client = Elasticsearch::Client.new host: host, log: true
  @client.indices.create index: index_name,
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
                                         title: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         creator: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         subject: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         description: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         publisher: {type: 'string',analyzer: 'ik_stem', store: 'yes'},
                                         contributor: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         date: {type: 'date', store: 'yes'},
                                         origin_date: {type: 'string', index: 'no', store: 'yes'},
                                         type: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
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

#导入oai数据
def import_oai_test_data index_name, path
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
      body_json = {
          "title" => get_field_value(xml_doc, '//dc:title'),
          "creator" => get_field_value(xml_doc, '//dc:creator'),
          "subject" => get_field_value(xml_doc, '//dc:subject'),
          "descripton" => get_field_value(xml_doc, '//dc:descripton'),
          "publisher" => get_field_value(xml_doc, '//dc:publisher'),
          "contributor" => get_field_value(xml_doc, '//dc:contributor'),
          "date" => get_field_value(xml_doc, '//dc:date'),
          "type" => get_field_value(xml_doc, '//dc:type'),
          "format" => get_field_value(xml_doc, '//dc:format'),
          "identifier" => get_field_value(xml_doc, '//dc:identifier'),
          "source" => get_field_value(xml_doc, '//dc:source'),
          "language" => get_field_value(xml_doc, '//dc:language'),
          "relation" => get_field_value(xml_doc, '//dc:relation'),
          "coverage" => get_field_value(xml_doc, '//dc:coverage'),
          "rights" => get_field_value(xml_doc, '//dc:rights'),
          "harvest_time" => Time.now
      }
      begin
        parsed_date = Date.parse(xml_doc.xpath('//dc:date').text) unless xml_doc.xpath('//dc:date').text==''
        body_json["date"] = get_field_value(xml_doc, '//dc:date')
      rescue
        puts xml_doc.xpath('//dc:date').text
      end

      begin
        @client.index index: index_name, type: 'item', body: body_json
      rescue Exception=>e
        logger.error e.message
        logger.error body_json
      end
    end
    puts index
  end

end

def get_field_value xml_doc, xpath
  result=''
  xml_doc.xpath(xpath).each_with_index do |item, index|
    if index==0
      result=item.text.strip
    else
      result = "#{result}|||#{item.text.strip}"
    end
  end
  return result
end