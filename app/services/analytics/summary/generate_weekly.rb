# frozen_string_literal: true

module Analytics
  module Summary
    class GenerateWeekly
      def initialize(client: Analytics::Client.new)
        @client = client
      end

      def call(user:, start_date:, end_date:)
        @user = user
        @start_date = start_date
        @end_date = end_date

        return nil unless journal_entries.present?

        create_weekly_summary
      end

      private

      attr_reader :client, :user, :start_date, :end_date

      def create_weekly_summary
        note = retrieve_weekly_summary

        return nil unless note

        summary = ::Summary::Weekly.find_or_initialize_by(user_id: user.id, start_date:, end_date:)
        summary.note = note

        summary.save ? summary : nil
      end

      def retrieve_weekly_summary
        response = client.call(messages:, temperature: 0.9)

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
            "content": "
              You are given the summaries of the days during the last week.
              Please, summarize the week in one sentence.
            ",
          },
        ] + messages_by_notes

      end

      def messages_by_notes
        journal_entries.map do |journal_entry|
          {
            "role": "user",
            "content": "#{journal_entry.entry_date.strftime("%A")}: #{journal_entry.note}",
          }
        end
      end

      def journal_entries
        return @_journal_entries if defined? @_journal_entries

        @_journal_entries = user.journal_entries
          .where("entry_date >= :start_date AND entry_date <= :end_date", start_date:, end_date:)
      end
    end
  end
end
