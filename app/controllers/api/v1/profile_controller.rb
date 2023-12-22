# frozen_string_literal: true

module Api
  module V1
    class ProfileController < ApplicationController
      def statistics
        render json: statistics_body, status: :ok
      end

      def trends
        render json: trends_body, status: :ok
      end

      private

      def statistics_body
        {
          number_of_journal_entries: current_user.journal_entries.count,
          number_of_day_streak: current_user.number_of_day_streak,
        }
      end

      def trends_body
        {summaries:}
      end

      def summaries
        Summary::Daily.joins(:journal_entry)
          .where(journal_entry_id: journal_entries.pluck(:id))
          .order("journal_entries.entry_date")
          .map do |summary|
            {
              **summary.attributes,
              day: summary.journal_entry.entry_date.strftime("%A"),
              entry_date: summary.journal_entry.entry_date,
              mood: summary.journal_entry.mood && {
                score: summary.journal_entry.mood&.score,
                humanized: summary.journal_entry.mood&.word,
              },
            }
          end
      end

      def weekly_summary
        Summary::Weekly.find_by(start_date:, end_date:)
      end

      def journal_entries
        return @_journal_entries if defined? @_journal_entries

        @_journal_entries = current_user.journal_entries
          .where(
            "entry_date >= :start_date AND entry_date <= :end_date",
            start_date: params[:start_date],
            end_date: params[:end_date],
          )
      end
    end
  end
end
