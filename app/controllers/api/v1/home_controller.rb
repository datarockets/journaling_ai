# frozen_string_literal: true

module Api
  module V1
    class HomeController < ApplicationController
      def index
        render json: home_body, status: :ok
      end

      private

      def home_body
        {moods:, daily_summaries:, weekly_summary:}
      end

      def moods
        Mood.joins(:journal_entry)
          .where(journal_entry_id: journal_entries.pluck(:id))
          .order("journal_entries.entry_date")
          .map do |mood|
            {**mood.attributes, humanized: mood.word, day: mood.journal_entry.entry_date.strftime("%A")}
          end
      end

      def daily_summaries
        Summary::Daily.joins(:journal_entry)
          .where(journal_entry_id: journal_entries.pluck(:id))
          .order("journal_entries.entry_date")
          .map { |summary| {**summary.attributes, day: summary.journal_entry.entry_date.strftime("%A")} }
      end

      def weekly_summary
        Summary::Weekly.find_by(start_date:, end_date:)
      end

      def journal_entries
        return @_journal_entries if defined? @_journal_entries

        @_journal_entries = current_user.journal_entries
          .where("entry_date >= :start_date AND entry_date <= :end_date", start_date:, end_date:)
      end

      def start_date
        Time.zone.today.beginning_of_week
      end

      def end_date
        Time.zone.today.end_of_week
      end
    end
  end
end
