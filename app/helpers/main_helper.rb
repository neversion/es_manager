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

end
