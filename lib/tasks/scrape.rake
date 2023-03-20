task scraper: :environment do
  require 'scraper/bedelias'

  Scraper::Bedelias.scrape
end

namespace :scrape do
  desc "reads scraped_subjects.yml, scraped_subject_groups and scraped_prerequisites and if not already " +
       "in database creates them, else it updates them"
  task update_subjects: :environment do
    YmlLoader.load
  end
end
