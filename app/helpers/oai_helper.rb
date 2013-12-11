module OaiHelper
  def parse_timestamp ts
    time = Time.parse(ts)
    time.strftime "%Y-%m-%d %H:%M:%S"
  end
end
