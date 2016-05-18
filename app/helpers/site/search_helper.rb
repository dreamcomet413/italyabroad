module Site::SearchHelper
	def downcase_params(params)
		if params.downcase.include?('other')
			value =  params.downcase.gsub(' ', '-') 
		else
			value = params
		end
		return value
	end
end
