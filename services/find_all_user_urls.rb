# FInd all urls (owned and accessible) by a user
class FindAllUserUrls
	def self.call(username: )
		user = User.where(username: username).first
      my_urls + other_urls
	end
end