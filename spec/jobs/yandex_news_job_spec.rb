require 'rails_helper'

describe YandexNewsJob do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  it 'matches with enqueued job' do
    expect {
      described_class.perform_later
    }.to have_enqueued_job.on_queue('yandex_news')
  end
end