class HandleLocationEvent
  include Service

  require "cgi"

  def initialize(event, now_user, userId, client)
    @event = event
    @now_user= now_user
    @userId = userId
    @client = client
  end

  def call

        # もしすでに現在地の登録がある場合は削除する
        c_location = Currentlocation.find_by(user_id: @now_user.id)
        c_location.destroy if c_location.present?

        # 該当するユーザーに紐づけて、currentlocationsテーブルに保存する
        Currentlocation.create(
          # 送信者情報
          user_id: @now_user.id,
          # 住所
          address: @event['message']['address'],
          # 緯度
          latitude: @event['message']['latitude'],
          # 経度
          longitude: @event['message']['longitude']
        )

       # 現在地近くでできる Todo を５件ピックアップする
        @spots = Spot.near_spot(@now_user)
        todo_containers = []

        # each_with_index = 各要素とその要素のインデックスを取りながら繰り返し処理を行う
        @spots.each do |spot|
          todos = spot.todos.select { |t| !t.finished && t.user_id == @now_user.id }
          next if todos.empty?

          # 配列の最初の要素には地点名を入れる
          spot_name = spot.name

          # 各 ToDo データごとに配列を作り、それを元に todo_containers に追加
          count = 0
          todos.each do |todo|
            todo_container = [spot_name, todo.content, todo.id]
            todo_containers << todo_container
            count += 1
            break if count == 5
          end
        end


        #もしtodo_containersの中身がない場合は。あなたが登録したTodoで現在地近くでできるものはありませんでした。おすすめのtodoをやってみませんか？　＋　おすすめのTodoを出すようにする。
        if todo_containers.empty?

          # each_with_index = 各要素とその要素のインデックスを取りながら繰り返し処理を行う
          @spots.each do |spot|
            everyone_todos = spot.todos.select { |t| t.public == TRUE && t.user_id != @now_user.id }
            next if everyone_todos.empty?

            # 配列の最初の要素には地点名を入れる
            spot_name = spot.name

            # 各 ToDo データごとに配列を作り、それを元に todo_containers に追加
            count = 0
            everyone_todos.each do |todo|
              todo_container = [spot_name, todo.content, todo.id]
              todo_containers << todo_container
              count += 1
              break if count == 3
            end
          end

          if todo_containers.empty?
            empty_message = {
              "type": "text",
              "text": "あなたが登録したTodoで現在地近くでできるものはありませんでした。好きなことをやりましょう！"
            }
          else
            empty_message = {
              "type": "text",
              "text": "あなたが登録したTodoで現在地近くでできるものはありませんでした。近くでできるおすすめのTodoがあります。やってみませんか？"
            }
          end
        end

        # カルーセルのメッセージ作成
        carousel_contents = todo_containers.map do |todo_container|
          url = "https://www.google.com/maps/dir/?api=1&origin=&destination=" + CGI.escape(todo_container[0])

          {
            "type": "bubble",
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{todo_container[1]}",
                  "align": "center",
                  "margin": "xxl",
                  "size": "lg",
                  "wrap": true
                },
                {
                  "type": "text",
                  "text": "#{todo_container[0]}",
                  "align": "center",
                  "size": "md",
                  "margin": "xxl",
                  "wrap": true
                },
                {
                  "type": "button",
                  "action": {
                    "type": "uri",
                    "label": "MAP",
                    "uri": url
                  },
                  "color": "#718B92",
                  "margin": "xxl"
                }
              ]
            },
            "footer":{
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "button",
                  "action": {
                    "type": "postback",
                    "label": "できた！",
                    "data": "#{todo_container[2]}"
                  },
                  "style": "primary",
                  "color": "#F1B553"
                }
              ]
            }
          }          
        end

        # ユーザーの近くでできる Todo をカルーセルで通知する
        message = {
          "type": "flex",
          "altText": "今できるTodoをお知らせします。",
          "contents": {
            "type": "carousel",
            "contents": carousel_contents
          }
        }

    @client.push_message(@userId, empty_message) if empty_message.present?
    @client.push_message(@userId, message)
  end
end