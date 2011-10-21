require "rubygems"
require "bundler/setup"
require "green_shoes"
require "barometer"
require File.dirname(__FILE__) + "/dates_helper"

Barometer.config = { 1 => [:google], 2 => :yahoo }
DEFAULT_LOCATION = "Buenos Aires, Argentina"
REFRESH_FREQUENCY = 30*60

Shoes.app(:size => "800x600") do
  background "background.png"
  
  def update_weather_report
    location = @loc ? @loc.text : DEFAULT_LOCATION
    
    begin
      barometer = Barometer.new(location)
      @weather = barometer.measure(true)
      
      @weather_title.text = weather_title
      @weather_subtitle.text = weather_subtitle
      update_weather_forecast
    rescue Barometer::OutOfSources
      alert("Unable to fetch weather report for '#{location}'")
    end
  end
  
  def weather_title
    "#{@weather.current.temperature}, #{@weather.current.condition}"
  end
  
  def weather_subtitle
    "Humidity: #{@weather.current.humidity}%, wind: #{@weather.current.wind}"
  end
  
  def update_weather_forecast
    @weather_forecast.clear do
      @weather.forecast.each do |forecast|
        para "#{DatesHelper.format_date(forecast.date)}: #{forecast.condition}, high: #{forecast.high}, low: #{forecast.low}"
      end
    end
  end
  
  stack do
    tagline "Weather report for: "
    flow do
      @loc = edit_line(width: 400, text: DEFAULT_LOCATION)
      button("Update") { update_weather_report }
    end
    
    flow do
      @weather_title = title
      @weather_subtitle = subtitle
    end
    tagline "Forecast:"
    @weather_forecast = stack
  end
  
  update_weather_report
  every(REFRESH_FREQUENCY) { update_weather_report }
end

