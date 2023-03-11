require 'dotenv'
Dotenv.load

class WebhookController < ApplicationController
  def callback
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      #友達追加時に友達idをデータベースに追加
      when Line::Bot::Event::Follow
        puts event["source"]["userId"]
      #メッセ―ジが来たときに外出結果をデータベースに追加
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: "text",
            text: event.message["text"]
          }
          client.reply_message(event['replyToken'], message)
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

