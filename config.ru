Dir.glob('./{config,lib,models,queries,services,helpers,controllers}/init.rb').each do |file|
  require file
end

run UrlShortnerAPI