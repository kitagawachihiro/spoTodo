class HandlePostbackEvent
  include Service

  require 'cgi'

  def initialize(event, now_user, userId, client)
    @event = event
    @now_user = now_user
    @userId = userId
    @client = client
  end

  def call
    todo = Todo.find(@event['postback']['data'])
    todo.update(finished: true) if @now_user.todos.include?(todo)

    message = {
      "type": 'text',
      "text": "ヤッタネ🥳🎉㊗️\n\n良い経験ができましたか？\nレビューを書きたい場合は下記のボタンからどうぞ✍️"
    }

    review_button = {
      "type": 'flex',
      "altText": 'this is a flex message',
      "contents": {
        "type": 'bubble',
        "body": {
          "type": 'box',
          "layout": 'vertical',
          "contents": [
            {
              "type": 'text',
              "text": '🎉できた👏'
            },
            {
              "type": 'text',
              "text": todo.content.to_s,
              "margin": 'md',
              "size": 'lg',
              "wrap": true
            },
            {
              "type": 'button',
              "action": {
                "type": 'uri',
                "label": 'レビューを書く',
                "uri": "#{Settings.app[:url]}/todos/#{todo.id}/review/new"
              },
              "style": 'primary',
              "margin": 'xl',
              "color": '#718B92'
            }
          ]
        }
      }
    }

    @client.push_message(@userId, message)
    @client.push_message(@userId, review_button)
  end
end
