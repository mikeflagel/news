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
    lat_long = results.first.coordinates
    "#{lat_long[0]} #{lat_long[1]}"

    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=9b0b7dddd56b413ca0cb58b252b3ce41"
    news = HTTParty.get(url).parsed_response.to_hash
end