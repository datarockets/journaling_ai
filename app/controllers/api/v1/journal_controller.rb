# frozen_string_literal: true

module Api
  module V1
    class JournalController < ApplicationController
      def index
        render json: journal_body, status: :ok
      end

      private

      def journal_body
        {daily_summaries:, weekly_summaries:}
      end

      def daily_summaries
        current_user.summary_dailies
          .joins(:journal_entry)
          .order("journal_entries.entry_date")
          .map { |summary| {**summary.attributes, entry_date: summary.journal_entry.entry_date} }
      end

      def weekly_summaries
        current_user.summary_weeklies.order(:start_date)
      end

      def journal_entries
        return @_journal_entries if defined? @_journal_entries

        @_journal_entries = current_user.journal_entries
          .where("entry_date >= :start_date AND entry_date <= :end_date", start_date:, end_date:)
      end
    end
  end
end
