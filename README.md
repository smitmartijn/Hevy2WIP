# Syncing Hevy workouts to WIP

How to use:

1. Copy .env.example to .env.
2. Run `bundle` if you don't have dotenv installed globally, otherwise no need to run.
3. Get WIP key from: https://wip.co/api
4. Get Hevy keys from the Developer Tools when visiting https://hevy.com/ while logged in. Look for a XHR call, the headers will be in it.
5. Run `ruby sync.rb` manually or put it into a crontab.