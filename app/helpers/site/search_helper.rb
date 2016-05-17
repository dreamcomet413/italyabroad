module Site::SearchHelper
	def downcase_params(params)
		params.downcase.gsub(' ', '-') if params.downcase.include?('other')
	end
end
