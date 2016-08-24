class Api::GoalDetailSerializer < Api::GoalSerializer
  
  attributes :lines_data

  def lines_data
    GoalServices::DetailChartDataBuilder.new(object).build
  end

end
