class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.string :nome
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :templates, :nome, unique: true
  end
end
