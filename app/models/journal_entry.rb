# frozen_string_literal: true

class JournalEntry < ApplicationRecord
  belongs_to :user

  validates :note, :entry_date, presence: true
  validates :entry_date, uniqueness: { scope: :user_id }
end
