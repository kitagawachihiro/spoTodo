source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# 認証機能実装のためにsorceryを導入
gem 'sorcery'

# URL等の管理のため
gem 'config'

#`<module:HTML4>': uninitialized constant Nokogiri::HTML4 (NameError)発生のため追加
gem 'loofah'

#Linebot用
gem 'line-bot-api'

#bootstrap導入
gem 'bootstrap-sass'
gem 'jquery-rails'

#font-awesome
gem 'font-awesome-sass'

#住所取得のため　Geocoder
gem 'geocoder'

#かみなりを導入 rails5系を使用しているので、0.17.0(Rails5で動作するよう改善されている)
gem 'kaminari'

#かみなりのbootstrapレイアウト
gem 'bootstrap4-kaminari-views'

#検索機能
gem 'ransack'

#rakeタスク（Todo自動削除）の定期実行（cron）をrailsで使用するため
gem 'whenever', require: false

#cron実行時の警告メッセージ「already initialized constant Net::ProtocRetryError」回避のため
gem 'net-http'

#metaタグ設定
gem 'meta-tags'

#検証
gem 'pg'

#CORS設定
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
  gem 'sqlite3'
  gem 'rubocop', require: false

  gem 'factory_bot_rails', '~> 4.11'

end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  #gem 'chromedriver-helper' #2019年3月31日に廃止し、以降webdrivers推奨になっている
  gem 'webdrivers'

  #テスト
  gem 'rspec-rails'
end

# 本番環境用
group :production do
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'dockerfile-rails', :group => :development

gem 'sentry-ruby'

gem 'sentry-rails'
