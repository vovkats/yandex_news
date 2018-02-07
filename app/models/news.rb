class News < ApplicationRecord
  validates :title, :description, :time, :show_until, presence: true
end
