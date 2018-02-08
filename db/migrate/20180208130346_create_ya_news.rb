class CreateYaNews < ActiveRecord::Migration[5.1]
  def change
    create_table :ya_news do |t|
      t.string :title
      t.string :description
      t.datetime :time

      t.timestamps
    end
  end
end
