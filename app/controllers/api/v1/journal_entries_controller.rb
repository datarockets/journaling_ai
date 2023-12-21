# frozen_string_literal: true

module Api
  module V1
    class JournalEntriesController < ApplicationController
      def index
        render json: current_user.journal_entries.all, status: :ok
      end

      def show
        entry = current_user.journal_entries.find_by(entry_date: params[:date])

        if entry
          render json: journal_entry_body(entry), status: :ok
        else
          render json: {error: "Journal entry for user not found"}, status: :not_found
        end
      end

      def create
        result = JournalEntries::Create.new.call(
          note: params[:note],
          entry_date: params[:entry_date] || Time.zone.today,
          user: current_user,
        )

        unless result[:error].present?
          render json: result[:entry], status: :created
        else
          render json: {error: result[:error]}, status: :unprocessable_entity
        end
      end

      def update
        result = JournalEntries::Update.new.call(
          id: params[:id],
          note: params[:note],
          user: current_user,
        )

        unless result[:error].present?
          render json: result[:entry], status: :ok
        else
          render json: {error: result[:error]}, status: :unprocessable_entity
        end
      end

      private

      def journal_entry_body(entry)
        {id: entry.id, content: entry.note, summary: entry.summary_daily&.note, meme: nil}
      end
    end
  end
end
