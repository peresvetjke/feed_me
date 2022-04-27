module ApplicationHelper
  def date(date_time)
    period = Time.now - date_time
    period_minutes = period / 60
    period_hours = period_minutes / 60
    period_days = period_hours / 24

    if period_minutes < 60
      "#{period_minutes.to_i}min"
    elsif period_hours < 24
      "#{period_hours.to_i}h"
    elsif period_days < 30
      "#{period_days.to_i}d"
    else
      date.strftime("%d/%m/%Y on %I:%M%p")
    end
  end
end
