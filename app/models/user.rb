class User < ApplicationRecord
  has_many :outs, dependent: :destroy

  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["CHANNEL_SECRET"]
    config.channel_token = ENV["CHANNEL_TOKEN"]
  }

  def send_stats # 一人分の結果について文字列で返す
    user_stats_message = "直近の結果を通知するのだ！\n"
    #今週分
    to  = Time.current
    from    = (to - 6.day)
    week_out_cnt = Out.where(user_id: self.id, created_at: from...to, went_out: true).count
    week_tot_cnt = Out.where(user_id: self.id, created_at: from...to).count
    if week_tot_cnt == 0
      return user_stats_message + 
            "...と思ったら、まだデータがとれていなかったのだ...1回以上データがとれてからもう一度聞いてみるのだ！"
    end
    user_stats_message += "今週: " + stats_to_message(week_out_cnt, week_tot_cnt) + "\n"
    #今月分
    to  = Time.current
    from    = (to - 1.month)
    month_out_cnt = Out.where(user_id: self.id, created_at: from...to, went_out: true).count
    month_tot_cnt = Out.where(user_id: self.id, created_at: from...to).count
    user_stats_message += "今月: " + stats_to_message(month_out_cnt, month_tot_cnt) + "\n"
    return user_stats_message += oshimai_degree_message(week_out_cnt, week_tot_cnt)
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

  private

    def stats_to_message(out_cnt, tot_cnt)
      message = "#{out_cnt}/#{tot_cnt} " + " (#{(out_cnt.to_f / tot_cnt.to_f * 100.0).to_i}%)"
    end
 
    def oshimai_degree_message(out_cnt, tot_cnt)
      rate = (out_cnt.to_f / tot_cnt.to_f * 100).to_i
      message = ""
      case rate
      when 0...34
        message = "これはまずいのだ！お兄ちゃんはおしまいなのだ！"
      when 34...67
        message = "もっと外出した方がいいのだ！"
      else
        message = "いっぱい外出していてえらいのだ！この調子なのだ！"
      end
    end
end
