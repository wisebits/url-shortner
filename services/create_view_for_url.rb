# Service to create and save a new url view
class CreateViewForUrl
  def self.call(url:)
    puts "<<<<" + "passed" + ">>>>>"
    saved_view = View.new(location: "Hsinchu, Taiwan", ip_address: "127.0.0.1")

    #saved_view.save
    #url.add_view(saved_view)
  end
end
