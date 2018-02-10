class News < ApplicationRecord
  validates :title, :description, :time, :show_until, presence: true

  belongs_to :user
end
