class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :name
      t.integer :file_size
      t.references :user, null: false, foreign_key: true, index: true
      t.boolean :private, index: true

      t.timestamps
    end
  end
end
