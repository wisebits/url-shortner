## URL Shortner 

An URL shortner is a service that basically renders a shorter url for the one being provided (usually long). In this project, we will implement this service in a secure way that allows users to auto-generate a short URL that is secure and shareable among users with proper permission. Additionally, authors and users with the proper permission will be able to access a dashboard and obtain insights into the traffic information pertaining to the URL provided.

## Installation Instructions
```
> bundle install
> rackup
```

## Usage as of April 6th 2016

- GET /
  - DESCRIPTION => Home of API Service

- GET /api/v1/urls/
  - RETURNS => JSON
  - DESCRIPTION => Returns all saved URL details

- GET /api/v1/urls/:id.json
  - RETURNS => JSON
  - DESCRIPTION => Returns specified URL details

- POST /api/v1/urls/
  - SAMPLE REQUEST =>  curl -v -H "Accept: application/json" -H "Content-type: application/json" \ -X POST -d 
  "{\"link\": \"http://test.com\", \"title\": \"urltest\", \"description\": \"urltest\", \"public\": \"urltest\" }" \http://localhost:9292/api/v1/urls


## Contributors
* Nicole Weatherburne
* Elvis Saravia
* Aditya Utama Wijaya

## Team: Wisebits
![alt text](https://avatars.githubusercontent.com/u/17720935?v=3&s=200?raw=true)