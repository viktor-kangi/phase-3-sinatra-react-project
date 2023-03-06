class CreateMemes < ActiveRecord::Migration[6.1]
    def change
      create_table :memes do |t|
        t.string :title 
        t.text :description
        t.string :url 
        t.references :user 
        t.datetime :due
        t.datetime :createdAt 
        t.integer :status, default: 0
  
        
      end
    end
  end