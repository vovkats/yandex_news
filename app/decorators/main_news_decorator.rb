class MainNewsDecorator < Draper::Decorator

  def time
    if object.try(:time)
      object.time.strftime('%F %H:%M')
    else
      'Обновление времени'
    end
  end

  def title
    if object.try(:title)
      object.title
    else
      'Обновление заголовка'
    end
  end

  def description
    if object.try(:description)
      object.description
    else
      'Обновление описания'
    end
  end
end