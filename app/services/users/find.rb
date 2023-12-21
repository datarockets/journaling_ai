# frozen_string_literal: true

module Users
  class Find
    def call(username:)
      User.find_by(username:)
    end
  end
end
