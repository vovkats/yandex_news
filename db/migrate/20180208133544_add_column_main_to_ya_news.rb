class AddColumnMainToYaNews < ActiveRecord::Migration[5.1]
  def change
    add_column :ya_news, :main, :boolean, default: false
    add_index :ya_news, :main
  end
end
