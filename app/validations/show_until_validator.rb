class ShowUntilValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank? || (value.present? && value < Time.zone.now)
      record.errors[attribute] <<
        I18n.t('activerecord.errors.models.news.attributes.show_until.wrong_time')
    end
  end
end