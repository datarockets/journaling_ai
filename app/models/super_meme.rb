require 'net/http'
require 'uri'
require 'json'

class SuperMeme
  BASE_URI = 'https://app.supermeme.ai/api/v1'

  def initialize(api_key)
    @api_key = api_key
  end

  def generate_meme_image(text_summary)
    uri = URI("#{BASE_URI}/meme/text")
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{@api_key}")
    request.body = { text: text_summary }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    response.body
  end
end
