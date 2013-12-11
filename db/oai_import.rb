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
                                         creator: {type: 'multi_field', fields: {
                                             creator: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                             untouched: {type: 'string', index: 'not_analyzed'}
                                         }},
                                         subject: {type: 'multi_field', fields: {
                                             subject: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                             untouched: {type: 'string', index: 'not_analyzed'}
                                         }},
                                         description: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         publisher: {type: 'multi_field', fields: {
                                             publisher: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                             untouched: {type: 'string', index: 'not_analyzed'}
                                         }},
                                         contributor: {type: 'multi_field', fields: {
                                             contributor: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                             untouched: {type: 'string', index: 'not_analyzed'}
                                         }},
                                         date: {type: 'date', store: 'yes'},
                                         origin_date: {type: 'string', index: 'no', store: 'yes'},
                                         type: {type: 'multi_field', fields: {
                                             type: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                             untouched: {type: 'string', index: 'not_analyzed'}
                                         }},
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
    file_path = "#{path}/#{file_name_list[index]}"
    File.open file_path do |file|
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
          "contributor" => get_field_value(xml_doc, '//dc:contributor'),
          "origin_date" => get_field_value(xml_doc, '//dc:date'),
          "publisher" => get_field_value(xml_doc, '//dc:publisher'),
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
        body_json["date"] = Date.parse(xml_doc.xpath('//dc:date').text) unless xml_doc.xpath('//dc:date').text==''
      rescue
        #body_json["date"] = "1000-00-00"
      end
      begin
        @client.index index: index_name, type: 'item', body: body_json
      rescue Exception => e
        WORKER_LOG.error e.message
        WORKER_LOG.error file_path
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
