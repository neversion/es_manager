module OaiHelper
  def parse_time ts
    time = Time.parse(ts)
    time.strftime "%Y-%m-%d %H:%M:%S"
  end

  def oai_gen_facet_url type, str
    case str
      when "publisher"
        request.url
      when "subject"
        request.url
      when "subject"
        request.url
      when "subject"
        request.url
      when "subject"
        request.url
      when "subject"
        request.url
      when "subject"
        request.url
    end
    return ''
  end

  private
  def rebulid_parm str
    if params['pub']

    end
    request.url.gsub(/&f=[0-9]+/,'')
  end
end
