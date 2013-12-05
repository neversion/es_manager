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
      parsed_date = ''
      begin
        parsed_date = Date.parse(xml_doc.xpath('//dc:date').text) unless xml_doc.xpath('//dc:date').text==''
      rescue
        puts xml_doc.xpath('//dc:date').text
      end
      if parsed_date.length!=0
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
      else
        body_json = {
            "title" => get_field_value(xml_doc, '//dc:title'),
            "creator" => get_field_value(xml_doc, '//dc:creator'),
            "subject" => get_field_value(xml_doc, '//dc:subject'),
            "descripton" => get_field_value(xml_doc, '//dc:descripton'),
            "publisher" => get_field_value(xml_doc, '//dc:publisher'),
            "contributor" => get_field_value(xml_doc, '//dc:contributor'),
            "origin_date" => get_field_value(xml_doc, '//dc:date'),
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
      end
      begin
        @client.index index: 'oai_ik', type: 'item', body: body_json
      rescue
        binding.pry
        puts body_json
      end
    end
  end

end

def get_field_value xml_doc, xpath
  result=''
  xml_doc.xpath(xpath).each_with_index do |item,index|
    if index==0
      result=item.text.strip
    else
      result = "#{result}|||#{item.text.strip}"
    end
  end
  return result
end

def mapping_with_new_index
  host = "http://210.34.4.113:9200"
  @client = Elasticsearch::Client.new host: host, log: true
  @client.indices.create index: 'oai_ik',
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
                                         title: {type: 'string', analyzer: 'ik', store: 'yes'},
                                         creator: {type: 'string', analyzer: 'ik', store: 'yes'},
                                         subject: {type: 'string', analyzer: 'ik', store: 'yes'},
                                         description: {type: 'string', analyzer: 'ik', store: 'yes'},
                                         publisher: {type: 'string', store: 'yes'},
                                         contributor: {type: 'string', analyzer: 'ik', store: 'yes'},
                                         date: {type: 'date', store: 'yes'},
                                         origin_date: {type: 'string',index: 'no', store: 'yes'},
                                         type: {type: 'string', analyzer: 'ik', store: 'yes'},
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

def update_mapping index_name
  host = "http://210.34.4.113:9200"
  client = Elasticsearch::Client.new host: host, log: true
  binding.pry
  client.indices.put_mapping index: index_name, type: 'item', body: {
      item: {
          properties: {
              title: {type: 'string', analyzer: 'ik', store: 'yes', boost: 3.0},
              creator: {type: 'string', analyzer: 'ik', store: 'yes'},
              subject: {type: 'string', analyzer: 'ik', store: 'yes'},
              description: {type: 'string', analyzer: 'ik', store: 'yes'},
              publisher: {type: 'string', store: 'yes'},
              contributor: {type: 'string', analyzer: 'ik', store: 'yes'},
              date: {type: 'date', store: 'yes'},
              origin_date: {type: 'string',index: 'no', store: 'yes'},
              type: {type: 'string', analyzer: 'ik', store: 'yes'},
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
end

#导入站内搜索数据
def import_znss_data file_name
  File.open "#{Rails.root}/public/data/#{file_name}" do |f|
    json_str=''
    f.each_line do |line|
      json_str=json_str+line
    end
    json_obj = JSON.parse json_str
    host = "http://210.34.4.113:9200"
    @client = Elasticsearch::Client.new host: host, log: true
    json_obj.each do |item|
      @client.index index: 'znss', type: 'item', id: item['fields']['id'], body: item['fields']
    end

  end
end

#mapping_with_new_index
#import_test_data "/hd/metadata/data/guji"

#update_mapping "oai_ik"

#import_znss_data  "json_homepage_2013_12_4.txt"

