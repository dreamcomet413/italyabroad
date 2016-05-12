module Site::BaseHelper
	def get_small_box_grape_guide_image_path
		gg = SmallBoxSetting.find_by_box_title("grape_guides")
		path = get_path(gg)
	end
	def get_small_box_moods_image_path
		moods = SmallBoxSetting.find_by_box_title("moods")
		path = get_path(moods)
		return path
	end
	def get_small_box_cercavino_image_path
		cercavino = SmallBoxSetting.find_by_box_title('cercavino')
		path = get_path(cercavino)
		return path
	end
	def get_small_box_events_image_path
		events = SmallBoxSetting.find_by_box_title("upcoming_events")
		path = get_path(events)
		return path
	end
	def get_small_box_hampers_image_path
		events = SmallBoxSetting.find_by_box_title("hampers")
		path = get_path(events)
		return path
	end
	def get_small_box_community_image_path
		community = SmallBoxSetting.find_by_box_title("our_community")
		path = get_path(community)
		return path
	end
	def get_small_box_wine_club_image_path
		wine_club = SmallBoxSetting.find_by_box_title("wine_club")
		path = get_path(wine_club)
		return path
	end
	def get_small_box_andra_blog_image_path
		blog = SmallBoxSetting.find_by_box_title("andra_blog")
		path = get_path(blog)
		return path
	end
	def get_small_box_recipes_image_path
		recipes = SmallBoxSetting.find_by_box_title("share_italian_recipes")
		path = get_path(recipes)
		return path
	end
	def get_small_box_chef_image_path
		chef = SmallBoxSetting.find_by_box_title("sign_up_as_chef")
		path = get_path(chef)
		return path
	end
	def get_path(record)
		if record and record.image
            path = record.image.image_filename.try(:url)
        else 
        	path = '/images/missing.jpg'     
        end
        return path
	end
end
