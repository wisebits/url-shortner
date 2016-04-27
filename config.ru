Dir.glob('./{config,models,services,helpers,controllers}/init.rb').each do |file|
  require file
end

run UrlShortnerAPI