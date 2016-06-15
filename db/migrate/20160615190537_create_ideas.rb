class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :title
      t.string :x
      t.string :y
      t.string :size
      t.references :mindmap, index: true, foreign_key: true
      t.string :description
      t.string :url

      t.timestamps null: false
    end
  end
end
