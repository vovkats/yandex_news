class HomeController < ApplicationController

  def show
    @news = Op::AuthorsNews::Get.execute.decorate
  end
end