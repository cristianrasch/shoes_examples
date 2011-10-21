module DatesHelper
  extend self
  
  def format_date(date)
    date.strftime "%d/%m/%y"
  end
end
