class CreateMindmaps < ActiveRecord::Migration
  def change
    create_table :mindmaps do |t|
      t.string :title, null:false
      t.references :user
      t.string :description
      t.boolean :private, default: false

      t.timestamps null: false
    end
  end
end
