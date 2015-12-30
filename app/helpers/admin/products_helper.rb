module Admin::ProductsHelper

	def tweet_hashes(product)
		product.sub_categories.first.gsub(' ','')
	end
end
