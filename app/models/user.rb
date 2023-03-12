class User < ApplicationRecord
  has_many :outs, dependent: :destroy

  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["CHANNEL_SECRET"]
    config.channel_token = ENV["CHANNEL_TOKEN"]
  }

  def send_stats # 一人分の結果について文字列で返す
    user_stats_message = "直近の結果なのだ！"
  end

  def self.send_checkup #バッチ処理(rails runnerで実行)
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

  def self.send_stats_all #バッチ処理2
    users = User.all
    users.each do |user|
      message = {
        type: "text",
        text: user.send_stats
      }
      @client.push_message(user.user_id, message)
    end
  end
end
