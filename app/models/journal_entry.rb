# frozen_string_literal: true

class JournalEntry < ApplicationRecord
  has_one :mood, dependent: :destroy
  belongs_to :user

  validates :note, :entry_date, presence: true
  validates :entry_date, uniqueness: { scope: :user_id }
end
