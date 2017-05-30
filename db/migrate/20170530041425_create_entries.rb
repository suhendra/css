class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.references :user, foreign_key: true
      t.references :counter, foreign_key: true
      t.date :date
      t.string :feedback
      t.text :description

      t.timestamps
    end
  end
end
