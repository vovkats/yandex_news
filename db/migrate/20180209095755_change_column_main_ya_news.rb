class ChangeColumnMainYaNews < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:ya_news, :main, true)
  end
end
