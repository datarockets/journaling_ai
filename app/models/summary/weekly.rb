# frozen_string_literal: true

module Summary
  class Weekly < ApplicationRecord
    validates :note, :start_date, :end_date, presence: true

    belongs_to :user
  end
end
