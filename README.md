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

- `POST /api/v1/urls/:url_id/permissions/?`
	- SAMPLE REQUEST => curl -v -H "Accept: application/json" -H "Content-type: application/json" \ -X POST -d "{ \"status\": \"urltest\", \"description\": \"urltest\" }" \http://localhost:9292/api/v1/urls/1/permissions/

## Tux helpful commands
``` 
> tux

# an example to create a User
> u = User.new(:email => "ellfae@gmail.com", :username => "omarsar0")
> u.password = "omarsar0"
> u.save 

# an example to create Url
> u = Url.new(:title => "elvis blog")
> u.url = "http://elvissaravia.com"
> u.shorturl = u.url
> u.save

# an example to create Url via User
> @u = User.first
> @u.add_url(:full_url => "http://ibelmopan.com/", :title => "Visual Blog", :description => "just a visual blog", :short_url => "http://wisebits/ABCD")

# an example to create View for Url
> @url = Url.first
> @url.add_view(:location => "Hsinchu, Taiwan", :ip_address => "192.168.1.1")

```

## Contributors
* Nicole Weatherburne
* Elvis Saravia
* Aditya Utama Wijaya

## Relational Model
![alt text](https://github.com/wisebits/url-shortner/blob/db_hardening/public/model.jpg?raw=true)

## Team: Wisebits
![alt text](https://avatars.githubusercontent.com/u/17720935?v=3&s=200?raw=true)