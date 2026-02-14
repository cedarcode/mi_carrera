namespace :scraper do
  task subjects: :environment do
    require 'scraper/subjects_scraper'
    Scraper::SubjectsScraper.scrape
  end

  task current_semester: :environment do
    require 'scraper/current_semester_scraper'
    Scraper::CurrentSemesterScraper.scrape
  end
end

task scraper: ['scraper:subjects', 'scraper:current_semester']

task load_yml: :environment do
  YmlLoader.load
end
