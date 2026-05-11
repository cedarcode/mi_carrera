require 'rails_helper'
require 'scraper/base'

RSpec.describe Scraper::Base do
  let(:degree) { { id: 'test_degree', bedelias_name: 'TEST DEGREE' } }
  let(:plan) { '2023' }
  let(:scraper) { described_class.new(degree, plan) }

  describe '#total_pages' do
    let(:active_page) { instance_double(Capybara::Node::Element, text: active_page_number) }
    let(:last_button) { instance_double(Capybara::Node::Element, :[] => last_button_classes) }

    before do
      allow(scraper).to receive(:find).with('.ui-paginator-last').and_return(last_button)
      allow(scraper).to receive(:find).with('.ui-paginator-page.ui-state-active').and_return(active_page)
      allow(scraper).to receive(:has_selector?).and_return(true)
      allow(scraper).to receive(:has_css?).with('.ui-paginator-page').and_return(true)
    end

    context 'when there are multiple pages (last-page button enabled)' do
      let(:last_button_classes) { 'ui-paginator-last ui-state-default ui-corner-all' }
      let(:active_page_number) { '7' }

      it 'clicks the last-page button and returns the active page number' do
        expect(last_button).to receive(:click)

        expect(scraper.send(:total_pages)).to eq(7)
      end
    end

    context 'when there is a single page (last-page button starts disabled)' do
      let(:last_button_classes) { 'ui-paginator-last ui-state-default ui-corner-all ui-state-disabled' }
      let(:active_page_number) { '1' }

      it 'does not click the disabled last-page button and returns 1' do
        expect(last_button).not_to receive(:click)

        expect(scraper.send(:total_pages)).to eq(1)
      end
    end

    context 'when there are zero results (no .ui-paginator-page in the DOM)' do
      let(:last_button_classes) { '' }
      let(:active_page_number) { '' }

      before do
        allow(scraper).to receive(:has_css?).with('.ui-paginator-page').and_return(false)
      end

      it 'returns 0 without touching the paginator' do
        expect(scraper).not_to receive(:find)

        expect(scraper.send(:total_pages)).to eq(0)
      end
    end
  end

  describe '#threaded_scrape' do
    it 'returns an empty array without spawning threads when max_pages is 0' do
      expect(Thread).not_to receive(:new)

      expect(scraper.send(:threaded_scrape, 0) { raise 'should not run' }).to eq([])
    end
  end
end
