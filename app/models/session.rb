class Session < ActiveRecord::Base

	def self.destroy_expire
		Session.where("created_at < ? " , (Time.now - 2.month).to_time).destroy_all
	end
end