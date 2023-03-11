require 'line/bot'
require 'dotenv'
Dotenv.load

client ||= Line::Bot::Client.new { |config|
  config.channel_secret = ENV["CHANNEL_SECRET"]
  config.channel_token = ENV["CHANNEL_TOKEN"]
}

template = {
  "type": "template",
  "altText": "confirm template checking if went out",
  "template": {
    "type": "confirm",
    "text": "今日外出したか答えるのだ！",
    "actions": [
      {
        "type": "message",
        "label": "はい",
        "text": "はい"
      },
      {
        "type": "message",
        "label": "いいえ",
        "text": "いいえ"
      }
    ]
  }
}

client.broadcast(template)