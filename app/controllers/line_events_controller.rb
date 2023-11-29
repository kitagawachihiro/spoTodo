class LineEventsController < ApplicationController
  # postが受けられないため除外
  protect_from_forgery :except => [:recieve]

  # line_events_controller.rb
  require 'line/bot' # gem 'line-bot-api' 

  # clientを定義
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = Rails.application.credentials.dig(:line, :message_channel_id)
      config.channel_secret = Rails.application.credentials.dig(:line, :message_channel_secret)
      config.channel_token = Rails.application.credentials.dig(:line, :message_channel_token)
    }
  end

  # イベント受信
  def recieve
    body = request.body.read

    # 署名の検証
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    # イベントが誰から送られてきたかuseridを確認
    events.each do |event|
      handle_event(event)
    end

    'OK'
  end

    private

  def handle_event(event)
    userId = event['source']['userId']  #userId取得
  
      #ユーザーがAuthenticationsテーブルに登録済みの人であるか確認し、ユーザーを取得する
      now_user = User.joins(:authentication).find_by(authentications: { uid: userId })
  
      #イベントがメッセージの場合
      case event
      when Line::Bot::Event::Message # Messageの場合
  
      #さらに位置情報だった場合
        case event.type
        when Line::Bot::Event::MessageType::Location
  
            #もしすでに現在地の登録がある場合は削除する
            c_location = Currentlocation.find_by(user_id: now_user.id)
            c_location.destroy if c_location.present?
  
            #該当するユーザーに紐づけて、currentlocationsテーブルに保存する
              Currentlocation.create(
                #送信者情報
                user_id: now_user.id, 
                #住所
                address: event['message']['address'], 
                #緯度
                latitude: event['message']['latitude'], 
                #経度
                longitude: event['message']['longitude']
              )
  
              #ユーザーの近くでできるTodoリストURLを返信をする
              message={
  
              #内容を編集する
                "type": 'flex',
                "altText": "近くでできるtodoはこちら↓ #{Settings.app[:url]}/currentlocations?user_id=#{now_user.id}&openExternalBrowser=1",
                "contents": {
                  "type": 'bubble',
                  "hero": {
                    "type": 'image',
                    "url": 'https://i.gyazo.com/3e34a4d3fe1f0c60742dc02d1aead03e.png',
                    "size": 'full',
                    "aspectRatio": '20:13',
                    "aspectMode": 'cover',
                    "action": {
                      "type": 'uri',
                      "uri": "#{Settings.app[:url]}/currentlocations?user_id=#{now_user.id}&openExternalBrowser=1"
                    }
                  },
                  "body": {
                    "type": 'box',
                    "layout": 'vertical',
                    "contents": [
                      {
                        "type": 'text',
                        "weight": 'bold',
                        "size": 'xl',
                        "text": 'Todoリストができました'
                      },
                      {
                        "type": 'box',
                        "layout": 'vertical',
                        "margin": 'lg',
                        "spacing": 'sm',
                        "contents": [
                          {
                            "type": 'box',
                            "layout": 'baseline',
                            "spacing": 'sm',
                            "contents": [
                              {
                                "type": 'text',
                                "text": '今いる場所の近くでできるTodoをピックアップしました',
                                "color": '#aaaaaa',
                                "size": 'sm',
                                "margin": 'none',
                                "contents": [
                                  {
                                    "type": 'span',
                                    "text": '今いる場所の近くでできるTodoをピックアップしました',
                                    "style": 'normal',
                                    "decoration": 'none',
                                    "weight": 'regular',
                                    "size": 'md'
                                  }
                                ],
                                "wrap": true
                              }
                            ],
                            "offsetTop": 'none'
                          }
                        ]
                      }
                    ]
                  },
                  "footer": {
                    "type": 'box',
                    "layout": 'vertical',
                    "spacing": 'sm',
                    "contents": [
                      {
                        "type": 'button',
                        "style": 'link',
                        "height": 'sm',
                        "action": {
                          "type": 'uri',
                          "label": 'リストへ',
                          "uri": "#{Settings.app[:url]}/currentlocations?user_id=#{now_user.id}&openExternalBrowser=1"
                        }
                      },
                      {
                        "type": 'box',
                        "layout": 'vertical',
                        "contents": [],
                        "margin": 'sm'
                      }
                    ],
                    "flex": 0
                  }
                }
  
              }
  
              
              user_id =  userId
              response = client.push_message(user_id, message)
  
        end
      end
  end
  end