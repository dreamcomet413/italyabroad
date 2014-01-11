class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.string :question,:null=>false
      t.text :answer
      t.references :user
      t.boolean :publish,:default=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :faqs
  end
end

