# frozen_string_literal: true

module Users
  class Create
    def call(params)
      User.create!(params)
    end
  end
end
