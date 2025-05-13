# frozen_string_literal: true

require "rails_helper"

RSpec.describe ButtonComponent, type: :component do
  it "renders a submit button" do
    render_inline(described_class.new(type: "submit").with_content('Test'))
    expect(page).to have_button('Test', type: 'submit')
  end

  it "renders a disabled button" do
    render_inline(described_class.new(type: 'button', disabled: true).with_content('Test'))
    expect(page).to have_button('Test', disabled: true)
  end
end
