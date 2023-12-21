# frozen_string_literal: true

module JournalEntries
  class Update
    def initialize(generate_summary: Analytics::GenerateSummary.new)
      @generate_summary = generate_summary
    end

    def call(id:, note:, user:)
      entry = user.journal_entries.find_by(id:)

      return {error: "Journal entry for user not found"} unless entry

      entry.note = note

      ActiveRecord::Base.transaction do
        if entry.save
          result = generate_summary.call(user:, entry_date: entry.entry_date)

          {entry:, **result}
        else
          {error: entry.errors.full_messages.join(", ")}
        end
      end
    end

    private

    attr_reader :generate_summary
  end
end
