class MainController < ApplicationController

  def import
    #import_data
  end

  def s
    @result={}
    if params[:q]
      @result = search_with_facet(params[:q],1,5,'create_timestamp')
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @result }
    end
  end

  private
  def mapping
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
                                           r_id: {type: 'string', index: 'no_analyzed', store: 'yes'},
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

  def search_with_facet q,page,size,sort_field
    host = "http://210.34.4.113:9200"
    @client = Elasticsearch::Client.new host: host, log: true

    @client.search index: 'znss',
                   body: {
                       query: { match: { title: q } },
                       "sort" => {sort_field => {"order"=>"desc"}}, #排序
                       size: size, #每次返回结果数量
                       from: (page-1)*size, #偏移量 用于分页
                       facets: {
                           type_id: { terms: { field: 'type_id' } },
                           cat_id: { terms: { field: 'cat_id' } }
                       }
                   }
  end

  def import_data
    File.open "#{Rails.root}/public/data/json_librarian_2013_11_26.txt" do  |f|
      json_str=''
      f.each_line do |line|
        json_str=json_str+line
      end
      json_obj = JSON.parse json_str
      host = "http://210.34.4.113:9200"
      @client = Elasticsearch::Client.new host: host, log: true
      json_obj.each do |item|
        @client.index index:'znss', type: 'item', id: item['fields']['id'], body: item['fields']
      end

    end
  end
end
