require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpoTodo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Rails自体のアプリケーションの時刻の設定
    config.time_zone = 'Tokyo'

    # DBを読み書きする際に、DBに記録されている時間をどのタイムゾーンで読み込むかの設定
    config.active_record.default_timezone = :local

    # moduleを自動で読み込む設定
    config.autoload_paths += %W[#{config.root}/lib]

    # 不要なファイルを生成しないように設定
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
    end
  end
end
