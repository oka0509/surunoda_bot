require 'line/bot'
require 'dotenv'
Dotenv.load

client ||= Line::Bot::Client.new { |config|
  config.channel_secret = ENV["CHANNEL_SECRET"]
  config.channel_token = ENV["CHANNEL_TOKEN"]
}

#フォローしているユーザー一覧に対して、状況を通知する
#todo

#外出の程度
def oshimai_degree(out_cnt, tot_cnt)
end

