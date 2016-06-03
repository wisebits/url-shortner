# FInd all urls (owned and accessible) by a user
class FindAllUserUrls
	def self.call(id: )
	  base_user = BaseUser.first(id: id)
    base_user.urls + base_user.owned_urls
	end
end