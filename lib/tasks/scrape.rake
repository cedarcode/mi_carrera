namespace :scraper do
  task :subjects, [:degree_id, :plan] => :environment do |_t, args|
    require 'scraper/subjects_scraper'

    if args[:degree_id] && args[:plan]
      Scraper::SubjectsScraper.scrape_one(args[:degree_id], args[:plan])
    else
      Scraper::SubjectsScraper.scrape
    end
  end

  task :current_semester, [:degree_id, :plan] => :environment do |_t, args|
    require 'scraper/current_semester_scraper'

    if args[:degree_id] && args[:plan]
      Scraper::CurrentSemesterScraper.scrape_one(args[:degree_id], args[:plan])
    else
      Scraper::CurrentSemesterScraper.scrape
    end
  end
end

task scraper: ['scraper:subjects', 'scraper:current_semester']

task load_yml: :environment do
  YmlLoader.load
end
