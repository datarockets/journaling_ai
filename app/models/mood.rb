# frozen_string_literal: true

class Mood < ApplicationRecord
  belongs_to :journal_entry

  validates :score, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100,
  }

  SCORE_TO_WORD = {
    0..25 => "Sad",
    26..50 => "Normal",
    51..75 => "Good",
    76..100 => "Great",
  }.freeze

  def word
    return @_word if defined? @_word

    @_word = SCORE_TO_WORD.find { |key, _| key === score }&.second
  end
end
