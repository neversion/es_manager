require "#{Rails.root}/app/models/index_logger.rb"
#设置日志存储位置
worker_logfile = File.open("#{Rails.root}/log/index_#{Time.new.strftime('%Y-%m-%d')}.log", 'a')
worker_logfile.sync = true
WORKER_LOG = IndexLogger.new(worker_logfile)