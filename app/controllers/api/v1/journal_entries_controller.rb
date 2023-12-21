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
          render json: entry, status: :ok
        else
          render json: {error: "Journal entry for user not found"}, status: :not_found
        end
      end

      def create
        entry = current_user.journal_entries.new(
          note: params[:note],
          entry_date: params[:entry_date] || Time.zone.today,
        )

        if entry.save
          render json: entry, status: :created
        else
          render json: {error: entry.errors.full_messages.join(", ")}, status: :unprocessable_entity
        end
      end

      def update
        entry = current_user.journal_entries.find_by(id: params[:id])

        return render json: {error: "Journal entry for user not found"}, status: :not_found unless entry

        entry.note = params[:note]

        if entry.save
          render json: entry, status: :ok
        else
          render json: {error: entry.errors.full_messages.join(", ")}, status: :unprocessable_entity
        end
      end
    end
  end
end
