# Sync your Hevy workouts to WIP
#
# Martijn Smit
# https://twitter.com/smitmartijn
#
# NOTE: Be sure to set your API keys in .env

require 'net/http'
require 'uri'
require 'json'
require 'dotenv'
require_relative 'wip'
require_relative 'hevy'

Dotenv.load(File.join(__dir__, '.env'))

hevy = Hevy.new(api_key: ENV['HEVY_API_KEY'], auth_token: ENV['HEVY_AUTH_TOKEN'], hevy_username: ENV['HEVY_USERNAME'])
workout = hevy.fetch_workout

if workout.empty?
  puts 'No workout found, exiting...'
  exit
end

todo_message = "#{workout} #{ENV['WIP_TODO_HASHTAG']}"
wip = WIP.new(api_key: ENV['WIP_API_KEY'])

# Create todo
puts "Creating todo: #{todo_message}"
todo = wip.create_todo(body: todo_message)

# The ID from the newly created todo
todo_id = todo['id'].to_i

# Complete todo
puts "Completing todo with ID: #{todo_id}"
wip.complete_todo(todo_id)

puts 'Todo successfully completed!'
