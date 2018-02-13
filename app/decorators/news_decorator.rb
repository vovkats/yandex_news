class NewsDecorator < Draper::Decorator

  def time
    if object.time
      object.time.strftime('%F %H:%M')
    else
      'Обновление времени'
    end
  end

  def title
    if object.title
      object.title
    else
      'Обновление заголовка'
    end
  end

  def description
    if object.description
      object.description
    else
      'Обновление описания'
    end
  end
end