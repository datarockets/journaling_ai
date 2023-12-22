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

  def number_of_day_streak
    query = "
      WITH Streaks AS (
        SELECT
          MIN(entry_date) AS start_date,
          MAX(entry_date) AS end_date,
          COUNT(*) AS streak_length
        FROM (
          SELECT
            entry_date,
            entry_date - ROW_NUMBER() OVER (ORDER BY entry_date)::integer AS group_number
          FROM
            (SELECT DISTINCT entry_date FROM journal_entries) AS distinct_dates
        ) AS date_groups
        GROUP BY group_number
      )
      SELECT
        MAX(streak_length) AS max_streak
      FROM Streaks;
    "

    result = ActiveRecord::Base.connection.execute(query)

    result.values.flatten.first || 0
  end
end
