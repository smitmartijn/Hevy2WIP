# Sync your Hevy workouts to WIP
#
# Martijn Smit
# https://twitter.com/smitmartijn
#
require 'json'
require 'date'

class Hevy
  def initialize(api_key:, auth_token:, hevy_username:)
    @api_key = api_key
    @auth_token = auth_token
    @hevy_username = hevy_username
  end

  def http_headers
    {
      "x-api-key": @api_key.to_s,
      "auth-token": @auth_token.to_s,
      "Content-Type": 'application/json',
      "Referrer": 'https://hevy.com',
      "User-Agent": 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36'
    }
  end

  def http_request
    uri = URI.parse("https://api.hevyapp.com/user_workouts_paged?username=#{@hevy_username}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri, http_headers)
    # Send the request
    response = http.request(request)
    response.body
  end

  def get_first_workout(today_workouts)
    workout = today_workouts.first
    start_time = Time.at(workout['start_time'])
    end_time = Time.at(workout['end_time'])

    duration = (end_time - start_time).round(2)
    formatted_duration = Time.at(duration).utc.strftime('%H:%M:%S')

    "Workout: #{workout['name']}  for #{formatted_duration}: https://hevy.com/workout/#{workout['short_id']}"
  end

  def filter_on_today(workouts)
    workouts.select { |workout| Time.at(workout['start_time']).to_datetime.to_date == Date.today }
  end

  def fetch_workout
    hevy_result = http_request

    data = JSON.parse(hevy_result)
    workouts = data['workouts']

    today_workouts = filter_on_today(workouts)
    return '' if today_workouts.empty?

    # we're assuming there'll be one workout per day
    get_first_workout(today_workouts)
  end
end
