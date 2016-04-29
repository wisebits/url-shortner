# Service to save a new view for url
class CreateNewView
  def self.call(location:, ip_address:)
    saved_view = View.new()
    saved_view.location = location
    saved_view.ip_address = ip_address
    saved_view.save
  end
end
