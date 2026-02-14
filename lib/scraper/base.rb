require 'capybara'
require 'capybara/dsl'

module Scraper
  class Base
    include Capybara::DSL

    MAX_PAGES = ENV["MAX_PAGES"]&.to_i
    THREADS = (ENV['THREADS'] || 6).to_f

    def self.scrape
      configure_capybara

      degrees = Rails.configuration.degrees
      degrees.each do |degree|
        new(degree).scrape
      end
    end

    def self.configure_capybara
      Capybara.register_driver :selenium_chrome_headless_large do |app|
        options = ::Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless')
        options.add_argument('--window-size=1920,1080')

        ::Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
      end

      Capybara.configure do |config|
        config.default_driver = ENV["HEADLESS"] == "false" ? :selenium_chrome : :selenium_chrome_headless_large
        config.run_server = false
        config.save_path = "tmp/capybara"
        config.threadsafe = true
      end
    end

    def initialize(degree)
      @degree = degree
      @logger = Rails.logger.tagged("Scraper - #{degree[:bedelias_name]}")
    end

    private

    attr_reader :degree, :logger

    def write_yml(name, data)
      dir_path = Rails.root.join("db/data/#{degree[:id]}/#{degree[:current_plan]}")

      FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)

      File.write(dir_path.join("#{name}.yml"), data.to_yaml)
    end

    def select_degree_in_accordion
      execute_script("$.fx.off = true;") # Disable jQuery effects

      find('.ui-accordion-header', text: 'TECNOLOGÍA Y CIENCIAS DE LA NATURALEZA').click
      find('td', text: 'FING - FACULTAD DE INGENIERÍA', visible: false).click

      find('span', text: ' - FING')

      wait_for_loading_widget_to_disappear

      find('.ui-column-filter').set(degree[:bedelias_name])

      all('tr', text: degree[:bedelias_name], match: :prefer_exact).each do |row|
        if row.has_selector?('td', text: 'Grado', match: :prefer_exact)
          row.find('.ui-row-toggler').click
          break
        end
      end
    end

    def go_to_page(page)
      # Loop until the desired page is visible in the paginator
      until page_visible?(page)
        last_visible_page = all('.ui-paginator-page').last

        last_visible_page.click
        has_selector?('.ui-paginator-page.ui-state-active', text: last_visible_page.text)
      end

      find('.ui-paginator-page', text: page, match: :prefer_exact).click
      has_selector?('.ui-paginator-page.ui-state-active', text: page.to_s)
    end

    def page_visible?(page)
      has_selector?('.ui-paginator-page', text: page, match: :prefer_exact)
    end

    def wait_for_loading_widget_to_disappear
      if has_css?('.ui-widget-overlay')
        assert_no_selector('.ui-widget-overlay')
      end
    end

    def total_pages
      find('.ui-paginator-last').click
      has_selector?(".ui-paginator-last.ui-state-disabled")

      find(".ui-paginator-page.ui-state-active").text.to_i
    end

    def threaded_scrape(max_pages)
      Thread.abort_on_exception = true

      1.upto(max_pages).each_slice((max_pages / THREADS).ceil).map do |slice|
        Thread.new do
          using_session(Capybara::Session.new(page.mode)) do
            yield(slice)
          end
        end
      end.flat_map(&:value)
    end
  end
end
