require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

ForecastIO.api_key = "f1cfe18c86ee64a2b13c6ce023ec052f"

get "/" do
  view "ask"
end
get "/news" do
results = Geocoder.search(params["q"])
    @lat_long = results.first.coordinates 
    @location = results.first.city
@lat = "#{@lat_long [0]}"
@long = "#{@lat_long [1]}"
@forecast = ForecastIO.forecast("#{@lat}" , "#{@long}").to_hash
@current_temperature = @forecast["currently"]["temperature"]
@current_conditions = @forecast["currently"]["summary"]
  @daily_temperature = []
  @daily_conditions = []
  @daily_wind = []
  @daily_humidity = []
for @day_forecast in @forecast["daily"]["data"] do
  @daily_temperature << @day_forecast["temperatureHigh"]
  @daily_conditions << @day_forecast["summary"]
  @daily_wind << @day_forecast["windSpeed"]
  @daily_humidity << @day_forecast["humidity"]
end
@list = @daily_temperature, @daily_conditions, @daily_wind, @daily_humidity

url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=9b0b7dddd56b413ca0cb58b252b3ce41"
@news = HTTParty.get(url).parsed_response.to_hash
  @news_title = []
  @story_url = []
for daily_news in @news["articles"] do
  @news_title << daily_news["title"]
  @story_url << daily_news["url"]
  
end
@newslist = @news_title, @story_url
view "news"

end