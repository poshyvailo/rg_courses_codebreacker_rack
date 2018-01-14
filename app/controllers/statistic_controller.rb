# frozen_string_literal: true

# Statistic controller
class StatisticController < Controller
  # /statistic
  def index
    @statistic = Statistic.load
    render
  end
end