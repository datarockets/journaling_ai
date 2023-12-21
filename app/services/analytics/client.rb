# frozen_string_literal: true

module Analytics
  class Client
    def initialize(http_client: Faraday)
      @http_client = http_client
    end

    def call(messages:, **args)
      @messages = messages
      @args = args

      request
    end

    private

    HOST = "https://api.openai.com".freeze
    BASE_URL = "/v1/chat/completions".freeze
    TOKEN = "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".freeze
    MODEL = "gpt-3.5-turbo".freeze

    attr_reader :http_client, :messages, :args

    def request
      client.post(BASE_URL) do |req|
        req.body = body
      end
    end

    def client
      @_client ||= http_client.new(url: HOST) do |f|
        f.request :json
        f.request :authorization, "Bearer", TOKEN
        f.response :json
      end
    end

    def body
      {
        messages:,
        model: MODEL,
        **args,
      }
    end
  end
end
