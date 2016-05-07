# Service to create and save a new url view
class CreateView
  def self.call(location:, ip_address:)
    saved_view = View.new(location: location, ip_address: ip_address)
    saved_view.save
  end
end
