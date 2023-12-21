# frozen_string_literal: true

module JournalEntries
  class Create
    def initialize(generate_summary: Analytics::GenerateSummary.new)
      @generate_summary = generate_summary
    end

    def call(note:, entry_date: Time.zone.today, user:)
      entry = user.journal_entries.new(note:, entry_date:)

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
