# Add a permission to another owner's existing url
class AddPermissionForUrl
	def self.call(user:, url:)
		if url.owner.id != user.id
			user.add_url(url)
			true
		else
			false
		end
	end
end