module OaiHelper
  def parse_time ts
    time = Time.parse(ts)
    time.strftime "%Y-%m-%d %H:%M:%S"
  end
end
