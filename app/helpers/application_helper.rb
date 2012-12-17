module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)  
    base_title = "Topichog"
    if page_title.empty?
      base_title
    else     
      "#{base_title} | #{page_title}"
    end
  end
  
    # Returns the full meta on a per-page basis.
  def full_meta(page_meta)  
    base_meta = "Topichog"
    if page_meta.empty?
      base_meta
    else     
      "#{base_meta} | #{page_meta}"
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end  
  
  def shorten_with_bitly(url)
    # build url to bitly api
    user = ENV["bitly_Username"]
    apikey = ENV["bitly_API_Key"]
    version = "2.0.1"
    bitly_url = "http://api.bit.ly/shorten?version=#{version}&longUrl=#{url}&login=#{user}&apiKey=#{apikey}"
     
    # parse result and return shortened url
    buffer = open(bitly_url, "UserAgent" => "Ruby-ExpandLink").read
    result = JSON.parse(buffer)
    short_url = result['results'][url]['shortUrl']
  end
  
end

