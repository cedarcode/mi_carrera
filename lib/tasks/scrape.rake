task scraper: :environment do
  require 'scraper/bedelias'

  Scraper::Bedelias.scrape
end

task load_yml: :environment do
  YmlLoader.load
end
