# frozen_string_literal: true

class JournalEntry < ApplicationRecord
  belongs_to :user

  validates :note, :entry_date, presence: true
  validates :note, uniqueness: {scope: [:user_id, :entry_date]}
end
