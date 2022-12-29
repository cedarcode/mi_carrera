require 'bedelias_spider'

namespace :scrape do
  desc "scrape subject groups, subjects and their prerequisites from bedelias.udelar.edu.uy to json file"
  task subjects: :environment do
    BedeliasSpider.parse!(:parse_subjects, url: "https://bedelias.udelar.edu.uy")
    BedeliasSpider.parse!(:parse_prerequisites, url: "https://bedelias.udelar.edu.uy")
  end
end
