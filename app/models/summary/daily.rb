# frozen_string_literal: true

module Summary
  class Daily < ApplicationRecord
    validates :note, presence: true

    belongs_to :journal_entry
  end
end
