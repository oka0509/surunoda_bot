class User < ApplicationRecord
  has_many :outs, dependent: :destroy

  #バッチ処理(rails runnerで実行)
  def User.send_checkup
    @client ||= Line::Bot::Client.new { |config|
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
    @client.broadcast(template)
  end

  #バッチ処理2
  def User.send_stats
    #todo
  end
end
