# FInd all urls (owned and accessible) by a user
class FindAllUserUrls
	def self.call(id: )
		user = User.where(id: id).first
      user.urls + user.owned_urls
	end
end