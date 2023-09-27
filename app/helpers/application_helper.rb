module ApplicationHelper

    def default_meta_tags
        {
          site: 'spoTodo',
          title: 'いつかやりたいを記録するサービス',
          reverse: true,
          charset: 'utf-8',
          description: 'spoTodoは" "いつかやりたい" ✖️ 場所 を記録するTodoリストサービスです。現在地を送信すると登録したTodoから今いる場所でできるTodoをお知らせします。',
          keywords: 'Todo,todo,spot,場所,いつか,いつかやりたい,記録,メモ',
          canonical: request.original_url,
          separator: '|',
          og: {
            site_name: :site,
            title: :title,
            description: :description,
            type: 'website',
            url: request.original_url, #ページの正規URLを指定します。
            image: image_url('ogp.png'), # 配置するパスやファイル名によって変更すること
            local: 'ja-JP'
          },
          # Twitter用の設定を個別で設定する
          twitter: {
            card: 'summary_large_image', # カードの種類 Twitterで表示する場合は大きいカードにする
            #site: '@', # アプリの公式Twitterアカウントがあれば、アカウント名を書く
            image: image_url('ogp.png') # 配置するパスやファイル名によって変更すること
          }
        }
      end

end
