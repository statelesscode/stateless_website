class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title, index: true
      t.text :text

      t.timestamps
    end
  end
end
