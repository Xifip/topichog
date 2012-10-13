#uri = URI.parse(ENV["REDISTOGO_URL"])
#REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#$redis = Redis.new(:host => 'localhost', :port => 6379)
if Rails.env.test? || Rails.env.cucumber?
  REDIS = Redis.new(:db => 1)
else
  redis_config_file = File.join(Rails.root,'config','redis.yml')
  raise "#{redis_config_file} is missing!" unless File.exists? redis_config_file
  redis_config = YAML.load_file(redis_config_file)[Rails.env].symbolize_keys

  REDIS = Redis.new(:host => redis_config[:host], :port => redis_config[:port], :password => redis_config[:password])
end  
