class YaNews < ApplicationRecord
  validates :title, :description, :time, presence: true
end
