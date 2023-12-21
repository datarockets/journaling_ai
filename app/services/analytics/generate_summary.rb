# frozen_string_literal: true

module Analytics
  class GenerateSummary
    def initialize(generate_daily: nil, generate_weekly: nil, generate_mood: nil)
      @generate_daily = generate_daily || Summary::GenerateDaily.new
      @generate_weekly = generate_weekly || Summary::GenerateWeekly.new
      @generate_mood = generate_mood || Summary::GenerateMood.new
    end

    def call(user:, entry_date:)
      @user = user
      @entry_date = entry_date.is_a?(Date) ? entry_date : entry_date.to_date

      daily = generate_daily.call(user:, entry_date:)
      mood = generate_mood.call(user:, entry_date:)
      weekly = generate_weekly.call(user:, start_date:, end_date:) if generate_weekly?

      {daily:, mood:, weekly:}
    end

    private

    attr_reader :generate_daily, :generate_weekly, :generate_mood, :user, :entry_date

    def generate_weekly?
      entry_date === end_date || end_date <= Time.zone.today
    end

    def start_date
      entry_date.beginning_of_week
    end

    def end_date
      entry_date.end_of_week
    end
  end
end
