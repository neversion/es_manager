class MainController < ApplicationController
  layout "znss"

  def s
    @result={}
    if params[:q]
      page_index = params[:p] || 1
      if !params.nil? && params[:s]=='1'
        @result = search_with_facet(params[:q], page_index.to_i, 10, 'create_timestamp', params[:f])
      else
        @result = search_with_facet(params[:q], page_index.to_i, 10, nil, params[:f])
      end
      @page_size=10

      @count=@result['hits']['total']
      if @count%@page_size==0
        @page_count=@count/@page_size
      else
        @page_count = @count/@page_size +1
      end
      @list=[]
      @facets =@result['facets']['type_id']['terms']
      @result['hits']['hits'].each do |item|
        item['_source']['body'] = item['highlight']['body'][0] unless item['highlight']['body'].nil?
        item['_source']['title'] = item['highlight']['title'][0] unless item['highlight']['title'].nil?
        @list << item['_source']
      end
    else
      #最新公告
      #@result = search_with_facet('厦门大学图书馆', 1, 10, 'create_timestamp', '32')
      @result = get_notices 1, 10
      @list=[]
      @result['hits']['hits'].each do |item|
        @list << item['_source']
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @result }
    end
  end

  private
  def search_with_facet q, page, size, sort_field, filter_id
    host = "http://210.34.4.113:9200"
    @client = Elasticsearch::Client.new host: host, log: true
    body_json = {
        "explain" => true,
        :query => {"query_string" =>
                       {"fields" => ["title^2", "body", "author", "source"],
                        "query" => "\"#{q}\""}},
        size: size, #每次返回结果数量
        from: (page-1)*size, #偏移量 用于分页
        facets: {
            type_id: {terms: {field: 'type_id'}},
            cat_id: {terms: {field: 'cat_id'}}
        },
        "highlight" => {
            "pre_tags" => [
                "<em>"
            ],
            "post_tags" => [
                "</em>"
            ],
            "fields" => {
                "title" => {},
                "body" => {}
            }
        }

    }
    if !sort_field.nil?
      body_json[:sort]= {sort_field => {"order" => "desc"}}
    end
    if !filter_id.nil?
      body_json[:filter]= {
          "term" => {"cat_id" => filter_id}
      }
      #body_json = {
      #    #"filtered" => {
      #        :query => {"query_string" => {"query" => "'#{q}"}},
      #        size: size, #每次返回结果数量
      #        from: (page-1)*size, #偏移量 用于分页
      #        facets: {
      #            type_id: {terms: {field: 'type_id'}},
      #            cat_id: {terms: {field: 'cat_id'}}
      #        },
      #        :filter => {
      #                    "term"=>{"cat_id"=>filter_id}
      #                }
      #
      #
      #    }
      ##}
    end

    @client.search index: 'znss', body: body_json
  end

  def get_notices page, size
    host = "http://210.34.4.113:9200"
    @client = Elasticsearch::Client.new host: host, log: true
    body_json = {
        "filter" => {
            "term" => {"cat_id" => 32}
        },

        size: size, #每次返回结果数量
        from: (page-1)*size, #偏移量 用于分页
        "sort" => {'create_timestamp' => 'desc'}
    }
    @client.search index: 'znss', body: body_json
  end
end
