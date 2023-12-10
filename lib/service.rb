module Service
  #ModelやControllerを構成する一部の概念や機能を実装するためのモジュール
  extend ActiveSupport::Concern

  class_methods do
    def call(*args)
      new(*args).call
    end
  end
end
