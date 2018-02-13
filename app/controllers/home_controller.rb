class HomeController < ApplicationController

  def show
    @news = MainNewsDecorator.decorate(Op::MainNews::Get.execute)
  end
end