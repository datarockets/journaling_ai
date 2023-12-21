# frozen_string_literal: true

module Analytics
  module Summary
    class GenerateMood
      def initialize(client: Analytics::Client.new)
        @client = client
      end

      def call(user:, entry_date:)
        @user = user
        @entry_date = entry_date

        return nil unless journal_entry

        create_mood
      end

      private

      attr_reader :client, :user, :entry_date

      def create_mood
        score = retrieve_mood&.split("/")&.second

        return nil unless score

        mood = Mood.find_or_initialize_by(journal_entry_id: journal_entry.id)
        mood.score = score

        mood.save ? mood : nil
      end

      def retrieve_mood
        response = client.call(
          messages:,
          max_tokens: 50,
          temperature: 0.5,
        )

        if response.success?
          response.body.dig("choices", 0, "message", "content")
        else
          nil
        end
      end

      def messages
        [
          {
            "role": "user",
            "content": "
              Please, analyze the sentiment of the following text: #{journal_entry.note}.
              Your response should include mood and estimation.
              Your available options to define mood: 'great', 'good', 'normal', 'sad'.
              The estimation should be from 1 to 100, where 1 - is absolute 'sad', and 100 - absolute 'great'.
              Example of your response 'Sad/23'.
            ",
          }
        ]
      end

      def journal_entry
        return @_journal_entry if defined? @_journal_entry

        @_journal_entry = user.journal_entries.find_by(entry_date:)
      end
    end
  end
end
