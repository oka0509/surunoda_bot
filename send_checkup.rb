require 'line/bot'
require 'dotenv'
Dotenv.load

client ||= Line::Bot::Client.new { |config|
  config.channel_secret = ENV["CHANNEL_SECRET"]
  config.channel_token = ENV["CHANNEL_TOKEN"]
}

template =  {
  "type": "template",    
  "altText": "daily checkup",   
  "template": {          
      "type": "buttons",  
      "text": "今日外出したか答えるのだ！",    
      "actions": [      
          # 1つ目のボタン
          {
            "type": "postback",
            "displayText": "はい",
            "label": "はい",
            "data": "はい"
          },
          # 2つ目のボタン
          {
            "type": "postback",
            "displayText": "いいえ",
            "label": "いいえ",
            "data": "いいえ"
          }
      ]
  }
}

client.broadcast(template)