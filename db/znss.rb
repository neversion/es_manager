
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
                                         title: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         creator: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         subject: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         description: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         publisher: {type: 'string', store: 'yes'},
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

def update_mapping index_name
  host = "http://210.34.4.113:9200"
  client = Elasticsearch::Client.new host: host, log: true
  binding.pry
  client.indices.put_mapping index: index_name, type: 'item', body: {
      item: {
          properties: {
              title: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
              creator: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
              subject: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
              description: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
              publisher: {type: 'string', store: 'yes'},
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
end

#新建znss索引并设置mapping
def znss_mapping
  host = "http://210.34.4.113:9200"
  @client = Elasticsearch::Client.new host: host, log: true
  @client.indices.create index: 'znss',
                         body: {
                             settings: {
                                 index: {
                                     number_of_shards: 1,
                                     number_of_replicas: 0,
                                 }
                             },
                             mappings: {
                                 item: {
                                     properties: {
                                         title: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         body: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         type_id: {type: 'short', store: 'yes'},
                                         cat_id: {type: 'short', store: 'yes'},
                                         url: {type: 'string', store: 'yes'},
                                         author: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         thumbnail: {type: 'string', store: 'yes'},
                                         source: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         create_timestamp: {type: 'long', store: 'yes'},
                                         update_timestamp: {type: 'long', store: 'yes'},
                                         hit_num: {type: 'integer', store: 'yes'},
                                         focus_count: {type: 'integer', store: 'yes'},
                                         grade: {type: 'short', store: 'yes'},
                                         comment_count: {type: 'integer', store: 'yes'},
                                         boost: {type: 'integer', store: 'yes'},
                                         integer_1: {type: 'integer', store: 'yes'},
                                         integer_2: {type: 'integer', store: 'yes'},
                                         integer_3: {type: 'integer', store: 'yes'},
                                         tag: {type: 'string', analyzer: 'ik_stem', store: 'yes'},
                                         display_text: {type: 'string', store: 'yes'},
                                     }
                                 }
                             }
                         }

end

#导入站内搜索数据
def import_znss_data file_list
  file_list.each do |file_name|
    File.open "#{Rails.root}/public/data/znss/#{file_name}" do |f|
      json_str=''
      f.each_line do |line|
        json_str=json_str+line
      end
      json_obj = JSON.parse json_str
      host = "http://210.34.4.113:9200"
      @client = Elasticsearch::Client.new host: host, log: true
      json_obj.each do |item|
        #if item['fields']['id'] == "homepage_667" || item['fields']['id'] == "homepage_691" || item['fields']['id'] == "homepage_702"
        #  item['fields']['body'] = remove_special item['fields']['body']
        #  binding.pry
        #end
        ##清理ik解析字段的所有前导空格
        #item['fields']['title'] = remove_special item['fields']['title']
        #item['fields']['body'] = remove_special item['fields']['body']
        #item['fields']['author'] = remove_special item['fields']['author']
        #item['fields']['source'] = remove_special item['fields']['source']
        #item['fields']['tag'] = remove_special item['fields']['tag']
        begin
          @client.index index: 'znss', type: 'item', id: item['fields']['id'], body: rebulid_json(item['fields'])
        rescue
          puts item['fields']['id']
        end
        #puts item['fields']['id']
      end
    end
    puts "#{file_name} done"
  end

end

#去除首尾普通空格及特殊空格
def remove_special str
  if !str.nil?
    while str[0]=='　'
      str = str[1..str.length-1]
    end
    while str[str.length-1]=='　'
      str = str[0..str.length-2]
    end
    str = str.strip
  end
  result = str
  return result
end

def rebulid_json json
  title = remove_special(json["title"])
  body = remove_special(json["body"])
  author =remove_special(json["author"])
  source =remove_special(json["source"])
  tag =remove_special(json["tag"])
  result = {
      title: title,
      body: body,
      type_id: json["type_id"],
      cat_id: json["cat_id"],
      url: json["url"],
      author: author,
      thumbnail: json["thumbnail"],
      source: source,
      create_timestamp: json["create_timestamp"],
      update_timestamp: json["update_timestamp"],
      hit_num: json["hit_num"],
      focus_count: json["focus_count"],
      grade: json["grade"],
      comment_count: json["comment_count"],
      boost: json["boost"],
      integer_1: json["integer_1"],
      integer_2: json["integer_2"],
      integer_3: json["integer_3"],
      tag: tag,
      display_text: json["display_text"]
  }
  #if json['id']== "homepage_667"
  #  binding.pry
  #end
  return result
end

#mapping_with_new_index
#import_test_data "/hd/metadata/data/guji"

#update_mapping "oai_ik"

#znss_mapping
#import_znss_data ["json_librarian_2013_11_26.txt"]

#s = "　致：厦门大学  读秀知识库于2006年9月中旬在厦门大学图书馆试用资源中开始对厦门大学师生提供试用，但是在试用过程中读者反在找到所需资源的最后通过''文献传递''到自己的信箱中时，读者一直是接收不到，现该问题已解决，请厦门大学师生放心试用，特此通知！               北京读秀有限责任公司"
#binding.pry
#a = remove_special s
#puts s
#binding.pry

