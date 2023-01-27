namespace :scrape do
  desc "scrape subject groups, subjects and their prerequisites from bedelias.udelar.edu.uy to YAML file"
  task subjects: :environment do
    require 'bedelias_spider'

    BedeliasSpider.new.parse_subjects_and_prerequisites
  end
end
