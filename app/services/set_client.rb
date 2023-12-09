class SetClient
  include Service

  # clientを定義
  def call
    @call ||= Line::Bot::Client.new do |config|
      config.channel_id = Rails.application.credentials.dig(:line, :message_channel_id)
      config.channel_secret = Rails.application.credentials.dig(:line, :message_channel_secret)
      config.channel_token = Rails.application.credentials.dig(:line, :message_channel_token)
    end
  end
end
