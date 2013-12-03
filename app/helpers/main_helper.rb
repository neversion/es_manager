module MainHelper
  #将时间戳解析成time
  def parse_timestamp ts
    time = Time.at(ts.to_i)
    time.strftime "%Y-%m-%d %H:%M:%S"
  end

  #生成分页url
  def gen_pre_url
    url = request.url
    if params[:p].nil? || params[:p].to_i==1
      return ''
    else
      page_str = "p="+params[:p]
      url = url.gsub(page_str, "p=#{params[:p].to_i-1}")
      return url
    end
  end

  def gen_next_url
    url = request.url
    if params[:p].nil?
      url = url+"&p=2"
    else
      if params[:p].to_i==@page_count
        return ''
      else
        page_str = "p="+params[:p]
        url = url.gsub(page_str, "p=#{params[:p].to_i+1}")
      end
    end
  end

  def gen_paging_url

  end

  def code_2_name code
    case code.to_i
      when 5
        return "文档"
      when 4
        return "服务"
      when 3
        return "资源"
      when 8
        return "共享平台"
      when 589
        return "概况"
      when 32
        return "公告"
      when -1
        return "全部"
    end
  end

  def gen_facet_url cat_id
    request.url + "&f=#{cat_id}"
  end

  def gen_all_url
    return request.url.gsub(/&f=[0-9]+/,'')
  end

  def gen_rel_sort_url
    return request.url.gsub(/&s=[0-9]+/,'')
  end

  def gen_time_sort_url
    request.url + "&s=1"
  end

  def gen_cur_page
    params[:p]
  end

  def gen_first_url
    return request.url.gsub(/&p=[0-9]+/,'&p=1')
  end

  def gen_last_url
    return request.url.gsub(/&p=[0-9]+/,"&p=#{@page_count}")
  end
end
