class News < ApplicationRecord
  validates :title, :description, :time, presence: true

  validates :show_until, show_until: true
  belongs_to :user
end
