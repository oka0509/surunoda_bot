require "dotenv"
Dotenv.load

class WebhookController < ApplicationController
  def callback
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Follow #フォロー時にデータベースに追加
        User.create(user_id: event["source"]["userId"])
        message = {
          type: "text",
          text: "はじめましてなのだ！外出の回数を増やすのだ！"
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::Unfollow #アンフォロー時にデータベースから削除
        User.find_by(user_id: event["source"]["userId"]).destroy
      when Line::Bot::Event::Postback #ボタンが押された時に外出記録をデータベースに追加
        @user = User.find_by(user_id: event["source"]["userId"])
        case event["postback"]["data"]
        when "はい"
          @user.outs.create(went_out: true)
        else
          @user.outs.create(went_out: false)
        end
      when Line::Bot::Event::Message  
        case event.type
        when Line::Bot::Event::MessageType::Text #統計データを求められたとき
          #todo
        end
      end
    end
  end

  private

    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["CHANNEL_SECRET"]
        config.channel_token = ENV["CHANNEL_TOKEN"]
      }
    end

    #外出の程度
    def oshimai_degree(out_cnt, tot_cnt)
    end
end
