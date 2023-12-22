# frozen_string_literal: true

class User < ApplicationRecord
  has_many :journal_entries, dependent: :destroy
  has_many :moods, through: :journal_entries
  has_many :summary_dailies, through: :journal_entries
  has_many :summary_weeklies, class_name: "Summary::Weekly", dependent: :destroy

  validates :username, presence: true

  def default_name
    full_name || username
  end

  def full_name
    return nil unless name && last_name

    "#{name} #{last_name}"
  end
end
