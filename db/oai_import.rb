#导入oai数据
def import_oai_test_data path
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
