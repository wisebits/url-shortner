## URL Shortner 

An URL shortner is a service that basically renders a shorter url for the one being provided (usually long). In this project, we will implement this service in a secure way that allows users to auto-generate a short URL that is secure and shareable among users with proper permission. Additionally, authors and users with the proper permission will be able to access a dashboard and obtain insights into the traffic information pertaining to the URL provided.

## Installation Instructions
```
> bundle install
> rackup
```

## Usage as of April 6th 2016

- `GET /`
  - DESCRIPTION => Home of API Service

- `GET /api/v1/urls/`
  - RETURNS => JSON
  - DESCRIPTION => Returns all saved URL details

- `GET /api/v1/urls/:id`
  - RETURNS => JSON
  - DESCRIPTION => Returns specified URL details and its relationships information (e.g. permissions)

- `GET /api/v1/urls/:id/permissions/?`
	- RETURN => JSON
	- DESCRIPTION => Return all permissions belonging to url

- `GET /api/v1/urls/:url_id/permissions/:id/?`
	- RETURN => JSON
	- DESCRIPTION => Return permission with specified ID

- `POST /api/v1/urls/`
  - SAMPLE REQUEST =>  curl -v -H "Accept: application/json" -H "Content-type: application/json" \ -X POST -d "{\"full_url\": \"http://test.com\", \"title\": \"urltest\", \"description\": \"urltest\" }" \http://localhost:9292/api/v1/urls
  - DESCRIPTION => Post a new url

- `POST /api/v1/urls/:url_id/permissions/?`
	- SAMPLE REQUEST => curl -v -H "Accept: application/json" -H "Content-type: application/json" \ -X POST -d "{ \"status\": \"urltest\", \"description\": \"urltest\" }" \http://localhost:9292/api/v1/urls/1/permissions/
  - DESCRIPTION => Post permission for a specific url

- `GET /api/v1/users/:username`
  - RETURNS => JSON
  - DESCRIPTION => Returns all owned urls for the specified user

- `GET /api/v1/users/:username/urls/?`
  - RETURNS => JSON
  - DESCRIPTION => Returns all owned urls and urls permitted to see for the specified user

- `POST /api/v1/users/?`
  - SAMPLE REQUEST =>  curl -v -H "Accept: application/json" -H "Content-type: application/json" \ -X POST -d "{\"username\": \"bob\", \"email\": \"bob@gmail.com\", \"password\": \"bobpass\" }" \http://localhost:9292/api/v1/users
  - DESCRIPTION => Post a new user account

- `POST /api/v1/users/:username/urls/?`
  - SAMPLE REQUEST =>  curl -v -H "Accept: application/json" -H "Content-type: application/json" \ -X POST -d "{\"username\": \"bob\", \"full_url\": \"http://testbob.com\", \"title\": \"urltestbob\", \"description\": \"urltestbob\" }" \http://localhost:9292/api/v1/users/bob/urls
  - DESCRIPTION => Post url for a specific user

- `GET /api/v1/urls/:id/views/?`
  - RETURN => JSON
  - DESCRIPTION => Return all views belonging to url

- `POST /api/v1/urls/:id/views/?`
  - SAMPLE REQUEST => curl -v -H "Accept: application/json" -H "Content-type: application/json" \ -X POST -d "{ \"location\": \"Hsinchu-Taiwan\", \"ip_address\": \"192.168.1.1\" }" \http://localhost:9292/api/v1/urls/1/views/
  - DESCRIPTION => Post view for a specific url

## Tux helpful commands
```ruby
tux

# an example to create a User
@user = User.new(:email => "ellfae@gmail.com", :username => "omarsar0")
@user.password = "omarsar0"
@user.save 

# an example to create Url
@url = Url.new(:title => "elvis blog")
@url.url = "http://elvissaravia.com"
@url.shorturl = @url.url
@url.save

# set owner to url
@user.add_owned_url(@url)

# set permission for user to an url through user
@user.add_url(@url)

# set permission for user to an url through url
@url.add_user(@user)

# retrieve user who have permission to a certain url
@url.users

# retrieve the owner of certain url
@url.owner

# retrieve permissions table
Permissions.all
+--------+-----------+-------------+------------+------------+
| url_id | viewer_id | description | created_at | updated_at |
+--------+-----------+-------------+------------+------------+
| 1      | 1         |             |            |            |
| 1      | 2         |             |            |            |
+--------+-----------+-------------+------------+------------+

# an example to create View for Url
@url = Url.first
@url.add_view(:location => "Hsinchu, Taiwan", :ip_address => "192.168.1.1")

```

## Contributors
* Nicole Weatherburne
* Elvis Saravia
* Aditya Utama Wijaya

## Relational Model
![alt text](https://github.com/wisebits/url-shortner/blob/authentication/public/design_model_v2.jpg?raw=true)

## Team: Wisebits
![alt text](https://avatars.githubusercontent.com/u/17720935?v=3&s=200?raw=true)