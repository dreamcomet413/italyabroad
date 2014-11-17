class CreateFaqs < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :faqs
      create_table :faqs do |t|
        t.string :question,:null=>false
        t.text :answer
        t.references :user
        t.boolean :publish,:default=>false
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :faqs
  end
end

