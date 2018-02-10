class NewsController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: NewsSerializer.new(Op::AuthorsNews::Get.execute)
  end

  def create
    news = Op::AuthorsNews::Save.execute(current_user.news.build,
                                         news_params)
    render json: NewsSerializer.new(news)
  end

  def update
    render json: NewsResultSerializer.new(
        Op::AuthorsNews::Update.execute(news_params))
  end

  private

  def news_params
    params.require(:news).permit(:title, :description, :show_until, :time)
  end
end