class MainController < ApplicationController

  def import
    host = "http://210.34.4.113:9200"
    @client = Elasticsearch::Client.new host: host, log: true
    @client.indices.create index: 'test',
                           body: {
                               settings: {
                                   index: {
                                       number_of_shards: 1,
                                       number_of_replicas: 0,
                                   }
                               },
                               mappings: {
                                   document: {
                                       properties: {
                                           r_id: {type: 'string', store: 'yes'},
                                           title: {type: 'string', analyzer: 'chinese', store: 'yes', boost: 3.0},
                                           body: {type: 'string', analyzer: 'chinese', store: 'yes'},
                                           type_id: {type: 'short', store: 'yes'},
                                           cat_id: {type: 'short', store: 'yes'},
                                           url: {type: 'string', store: 'yes'},
                                           author: {type: 'string', analyzer: 'chinese', store: 'yes'},
                                           thumbnail: {type: 'string', store: 'yes'},
                                           source: {type: 'string', analyzer: 'chinese', store: 'yes'},
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
                                           tag: {type: 'string', analyzer: 'chinese', store: 'yes'},
                                           display_text: {type: 'string', store: 'yes'}
                                       }
                                   }
                               }
                           }
  end


  private
  def mapping
    @client.indices.put_mapping index: 'test', type: 'record', body: {
        record: {
            properties: {
                r_id: {type: 'string', store: 'yes'},
                title: {type: 'string', analyzer: 'chinese', store: 'yes', boost: 3.0},
                body: {type: 'string', analyzer: 'chinese', store: 'yes'},
                type_id: {type: 'short', store: 'yes'},
                cat_id: {type: 'short', store: 'yes'},
                url: {type: 'string', store: 'yes'},
                author: {type: 'string', analyzer: 'chinese', store: 'yes'},
                thumbnail: {type: 'string', store: 'yes'},
                source: {type: 'string', analyzer: 'chinese', store: 'yes'},
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
                tag: {type: 'string', analyzer: 'chinese', store: 'yes'},
                display_text: {type: 'string', store: 'yes'}
            }
        }
    }

  end
end
