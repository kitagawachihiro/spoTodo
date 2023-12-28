class LineEventsController < ApplicationController
  # postが受けられないため除外
  protect_from_forgery :except => [:recieve]

  # line_events_controller.rb
  require 'line/bot' # gem 'line-bot-api' 
  

  # イベント受信
  def recieve
    body = request.body.read
    
    client = SetClient.call

    # 署名の検証
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    # イベントが誰から送られてきたかuseridを確認
    events.each do |event|
      userId = event['source']['userId']  # userId取得

      # ユーザーがAuthenticationsテーブルに登録済みの人であるか確認し、ユーザーを取得する
      now_user = User.joins(:authentication).find_by(authentications: { uid: userId })

      # イベントがメッセージの場合
      case event
      when Line::Bot::Event::Message # Messageの場合

        # さらに位置情報だった場合
        case event.type
        when Line::Bot::Event::MessageType::Location
          HandleLocationEvent.call(event, now_user, userId, client)
        end
      

      when Line::Bot::Event::Postback
        HandlePostbackEvent.call(event, now_user, userId, client)       
      end
    end

    # レスポンス
    head :no_content
    'OK'
  end
 
end