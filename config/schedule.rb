
# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + '/environment')

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

# シェル、コマンド設定
set :job_template, "/bin/zsh -l -c ':job'"

# job_type「rbenv_rake」を作成
# q!eval "$(rbenv init -)" ＝ rbenvを使用する初期設定
# eval = 引数で渡した文字列をRubyのプログラムとして実行するメソッド %q!=文字列作成宣言
env :PATH, ENV['PATH']
job_type :rbenv_rake, %q!eval "$(rbenv init -)"; cd :path && :environment_variable=:environment bundle exec rake :task --silent :output!

#定期実行したい処理を記入
every 1.day, :at => '0:00' do
    rbenv_rake 'delete:delete'
end
  

