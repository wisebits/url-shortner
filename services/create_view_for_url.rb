# Create new view for a url
class CreateViewForUrl
  def self.call(url:, ip_address:, location:)
    saved_view = url.add_view(CreateView.call(
      ip_address: ip_address,
      location: location))
    saved_view.save    
  end
end