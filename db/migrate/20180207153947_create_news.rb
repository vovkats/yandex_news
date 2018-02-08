class CreateNews < ActiveRecord::Migration[5.1]
  def change
    create_table :news do |t|
      t.string :title
      t.string :description
      t.datetime :time
      t.datetime :show_until
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
