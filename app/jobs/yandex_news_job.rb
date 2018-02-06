class YandexNewsJob < ApplicationJob
  queue_as :yandex_news

  def perform; end
end
