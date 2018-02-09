class YandexNewsJob < ApplicationJob
  queue_as :yandex_news

  def perform
    Op::YandexNews::Load.execute
  end
end
