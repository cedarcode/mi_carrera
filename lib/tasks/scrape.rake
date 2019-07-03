require 'bedelias_spider'

namespace :scrape do
  desc "scrape subjects and subject groups from bedelias.udelar.edu.uy to json file"
  task subjects: :environment do
    BedeliasSpider.parse!(:parse_subjects, url: "https://bedelias.udelar.edu.uy")
  end

  desc "scrape prerequisites from bedelias.udelar.edu.uy to json file"
  task prerequisites: :environment do
    BedeliasSpider.parse!(:parse_prerequisites, url: "https://bedelias.udelar.edu.uy")
  end

  desc "scrape prerequisite of particular subject from bedelias.udelar.edu.uy to stdout"
  task :prerequisite, [:subject_code] => [:environment] do |task, args|
    BedeliasSpider.parse!(:parse_prerequisite, url: "https://bedelias.udelar.edu.uy", data:{ subject_code: args[:subject_code] })
  end

end
