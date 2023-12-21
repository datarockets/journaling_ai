require 'json'

class MemeGeneration
  def initialize(text_summary, api_key)
    @text_summary = text_summary
    @client = SuperMeme.new(api_key)
  end

  def call
    response = @client.generate_meme_image(@text_summary)
    process_response(response)
  rescue StandardError => e
    error_response(e.message)
  end

  private

  def process_response(response)
    if response.code.to_i == 200
      success_response(JSON.parse(response.body))
    else
      error_message = JSON.parse(response.body)['error_message'] || 'An unknown error occurred'
      error_response(error_message)
    end
  end

  def success_response(parsed_response)
    {
      search_emotion: parsed_response['searchEmotion'],
      memes: parsed_response['memes'],
      status: 'success'
    }.to_json
  end

  def error_response(message)
    {
      error: message,
      status: 'error'
    }.to_json
  end
end
