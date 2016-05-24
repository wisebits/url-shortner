# Create users
user1 = CreateUser.call(
  username: 'alice', email: 'alice@gmail.com', password: 'alicepass')

user2 = CreateUser.call(
  username: 'bob', email: 'bob@gmail.com', password: 'bobpass')

# Create url for user
url11 = CreateUrlForOwner.call(
  user: user1, 
  full_url: "https://aliceinwonderland.com",
  title: "A world of wonders",
  description: "Alice in Wonderland")

# Create views for urls
view11 = CreateViewForUrl.call(
  url: url11,
  ip_address: "http://kansascity.com",
  location: "kansascity"
  )

view11 = CreateViewForUrl.call(
  url: url11,
  ip_address: "http://nowhereland.com",
  location: "nowhereland"
  )

# Create url for user
url12 = CreateUrlForOwner.call(
  user: user1, 
  full_url: "https://bobinwonderland.com",
  title: "A world of wonders",
  description: "bob in Wonderland")

view21 = CreateViewForUrl.call(
  url: url12,
  ip_address: "http://bobfromwashington.com",
  location: "washington"
  )

url21 = user2.add_owned_url(CreateUrl.call(
  full_url: "https://elvisinhsinchu.com",
  title: "A world of wonders",
  description: "elvis in hsinchu"))

user1.add_url(url21)

url22 = user2.add_owned_url(CreateUrl.call(
  full_url: "https://elaninhsinchu.com",
  title: "A world of wonders",
  description: "elan in hsinchu"))

puts 'Database seeded'
DB.tables.each { |table| puts "#{table} --> #{DB[table].count}"}