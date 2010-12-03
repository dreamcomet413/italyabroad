class ForumCreation < ActiveRecord::Migration
  def self.up
  
    create_table "forums", :force => true do |t|
	    t.string  "name"
	    t.string  "description"
	    t.integer "topics_count",     :default => 0
	    t.integer "posts_count",      :default => 0
	    t.integer "position"
	    t.text    "description_html"
	  end
	
	  create_table "moderatorships", :force => true do |t|
	    t.integer "forum_id"
	    t.integer "user_id"
	  end
	
	  add_index "moderatorships", ["forum_id"], :name => "index_moderatorships_on_forum_id"
	
	  create_table "monitorships", :force => true do |t|
	    t.integer "topic_id"
	    t.integer "user_id"
	    t.boolean "active",   :default => true
	  end

	  #add_column :posts, :topic_id, :integer
	  #add_column :posts, :forum_id, :integer
	  #add_column :posts, :body_html, :text

	  #add_index "posts", ["forum_id", "created_at"], :name => "index_posts_on_forum_id"
	  #add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id"
	  #add_index "posts", ["topic_id", "created_at"], :name => "index_posts_on_topic_id"
	
	  create_table "topics", :force => true do |t|
	    t.integer  "forum_id"
	    t.integer  "user_id"
	    t.string   "title"
	    t.text     "body", "body_html"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "hits",         :default => 0
	    t.integer  "sticky",       :default => 0
	    t.integer  "posts_count",  :default => 0
	    t.datetime "replied_at"
	    t.boolean  "locked",       :default => false
	    t.integer  "replied_by"
	    t.integer  "last_post_id"
	  end
	  
	  create_table "forum_posts", :force => true do |t|
	    t.integer  "forum_id"
	    t.integer  "user_id", "topic_id"
	    t.string   "title"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "hits",         :default => 0
	    t.integer  "sticky",       :default => 0
	    t.datetime "replied_at"
	    t.boolean  "locked",       :default => false
	    t.integer  "replied_by"
	    t.integer  "last_post_id"
	  end
	
	  add_index "forum_posts", ["forum_id", "created_at"], :name => "index_posts_on_forum_id"
	  add_index "forum_posts", ["user_id", "created_at"], :name => "index_posts_on_user_id"
	  add_index "forum_posts", ["topic_id", "created_at"], :name => "index_posts_on_topic_id"
	  
	  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"
	  add_index "topics", ["forum_id", "sticky", "replied_at"], :name => "index_topics_on_sticky_and_replied_at"
	  add_index "topics", ["forum_id", "replied_at"], :name => "index_topics_on_forum_id_and_replied_at"	
	  
		add_column :users, :posts_count, :integer, :default => 0
    add_column :users, :last_seen_at, :datetime
  
  end

  def self.down
    drop_table :forums
    drop_table :forum_posts
    drop_table :topics
    remove_column :users, :posts_count
    remove_column :users, :last_seent_at
  end
end
