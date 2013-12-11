class OaiController < ApplicationController
  layout "oai"

  #搜索首页
  def s
    @result={}
    if params[:q]
      page_index = params[:p] || 1
      if !params.nil? && params[:s]=='1'
        @result = search_with_facet(params[:q], page_index.to_i, 10, 'harvest_time', params[:f])
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
      @facets=[]
      @facets << @result['facets']['publisher']['terms']
      @facets << @result['facets']['subject']['terms']
      @facets << @result['facets']['date']['terms']
      @facets << @result['facets']['creator']['terms']
      @facets << @result['facets']['contributor']['terms']
      @facets << @result['facets']['rights']['terms']
      @result['hits']['hits'].each do |item|
        item['_source']['body'] = item['highlight']['body'][0] unless item['highlight']['body'].nil?
        item['_source']['title'] = item['highlight']['title'][0] unless item['highlight']['title'].nil?
        @list << item['_source']

      end
    else
      #最新公告

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
                       {"fields" => ["title^2", "creator", "subjext", "description", "contributor",
                                     "publisher", "type"],
                        "query" => "\"#{q}\""}},
        size: size, #每次返回结果数量
        from: (page-1)*size, #偏移量 用于分页
        facets: {
            publisher: {terms: {field: 'publisher.untouched'}},
            subject: {terms: {field: 'subject'}},
            date: {terms: {field: 'date'}},
            creator: {terms: {field: 'creator'}},
            contributor: {terms: {field: 'contributor'}},
            rights: {terms: {field: 'rights'}}
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
      #    }
      ##}
    end

    @client.search index: 'oai_ik_stem', body: body_json
  end
end
