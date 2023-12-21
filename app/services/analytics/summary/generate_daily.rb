# frozen_string_literal: true

module Analytics
  module Summary
    class GenerateDaily
      def initialize(client: Analytics::Client.new)
        @client = client
      end

      def call(user:, entry_date:)
        @user = user
        @entry_date = entry_date

        return nil unless journal_entry

        create_daily_summary
      end

      private

      attr_reader :client, :user, :entry_date

      def create_daily_summary
        note = retrieve_daily_summary

        return nil unless note

        summary = ::Summary::Daily.find_or_initialize_by(journal_entry_id: journal_entry.id)
        summary.note = note

        summary.save ? summary : nil
      end

      def retrieve_daily_summary
        response = client.call(messages:)

        if response.success?
          response.body.dig("choices", 0, "message", "content")
        else
          nil
        end
      end

      def messages
        [
          {
            "role": "system",
            "content": "You are a person who reflects on their day. Summarize the day in one sentence.",
          },
          {
            "role": "user",
            "content": journal_entry.note,
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
