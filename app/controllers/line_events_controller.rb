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
      HandleLineEvent.call(event, client)
    end

    'OK'
  end
 
end