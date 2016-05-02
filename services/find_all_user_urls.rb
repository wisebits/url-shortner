# FInd all urls (owned and accessible) by a user
class FindAllUserUrls
	def self.call(user)
		my_urls = Url.where(owner_id: user.id).all
      other_urls = Url.join(:permissions, url_id: :id).where(viewer_id: user.id).all
      my_urls + other_urls
	end
end