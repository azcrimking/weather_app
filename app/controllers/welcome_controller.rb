class WelcomeController < ApplicationController
  def index
    # Creates an array of states that our user can choose from on our index page
    @states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NB KS OK
         TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY
         NJ CT RI MA VT NH ME DC).sort!

    # removes spaces from the 2-word city names and replaces the space with an underscore
    if params[:city] != nil
      params[:city].gsub!(" ","_")
    end

    #checks that the state and city params are not empty before calling the API
    if params[:state] != "" && params[:city] != "" && params[:state] != nil && params[:city] != nil

    response = HTTParty.get("http://api.wunderground.com/api/#{ENV['weather_key']}/geolookup/conditions/q/#{params[:state]}/#{params[:city]}.json")

    #if no error is returned from the call, we fill our instants variables with the result of the call
    if response['response']['error'] == nil || results['error'] == ""

    #checks to see if the response contains an array (ambigous response for an invalid city/state combination) or a hash(valid response)
    if response.key?("location")
      @location = response['location']['city']
      @temp_f = response['current_observation']['temp_f']
      @temp_c = response['current_observation']['temp_c']
      @weather_icon = response['current_observation']['icon_url']
      @weather_words = response['current_observation']['weather']
      @forecast_link = response['current_observation']['forecast_url']
      @real_feel = response['current_observation']['feelslike_f']
    else
      @error = "City/State combination does not exist"
    end
  else
      #if there is an error, we report it to our user via the @error variable
      @error = response['response']['error']['description']
  end
end

end

  def test
    response = HTTParty.get("http://api.wunderground.com/api/#{ENV['weather_key']}/geolookup/conditions/q/AZ/Phoenix.json")

    @location = response['location']['city']
    @temp_f = response['current_observation']['temp_f']
    @temp_c = response['current_observation']['temp_c']
    @weather_icon = response['current_observation']['icon_url']
    @weather_words = response['current_observation']['weather']
    @forecast_link = response['current_observation']['forecast_url']
    @real_feel = response['current_observation']['feelslike_f']
  end

end
