# Add a permission to another owner's existing url
class AddPermissionForUrl
	def self.call(viewer_id:, url_id:)
		viewer = User.where(id: viewer_id.to_i).first
		url = Url.where(id: url_id.to_i).first
		if url.owner.id != viewer.id
			viewer.add_url(url)
			true
		else
			false
		end
	end
end