class AddMetaInfoToGrapesProducersRegions < ActiveRecord::Migration
  def change
  	change_table :grapes do |t|
	  	t.string   "page_title"
	    t.string   "meta_keys"
	    t.text     "meta_description"
	end

	change_table :producers do |t|
		t.string   "page_title"
    	t.string   "meta_keys"
    	t.text     "meta_description"
	end
  
	change_table :regions do |t|
		t.string   "page_title"
    	t.string   "meta_keys"
    	t.text     "meta_description"
	end

  end
end
