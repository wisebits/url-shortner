require 'openssl'
require 'base64'

module ApiHelper
	#generate the short url
	def short_url_creator(url)
	  s_url = "http://wise.url/"+ Base64.urlsafe_encode64(Digest::SHA256.digest(url))[0..6]
	end
end