# frozen_string_literal: true

require "rails_helper"

RSpec.describe CheckboxInputComponent, type: :component do
  it "renders the checbox with checked status" do
    render_inline(described_class.new("some_attribute", checked: true))

    expect(page).to have_css "input[type='checkbox'][name='some_attribute'][checked]"
    expect(page).to have_css "svg"
  end

  it "renders the checbox with unchecked status" do
    render_inline(described_class.new("some_attribute", checked: false))

    expect(page).to have_css "input[type='checkbox'][name='some_attribute']"
    expect(page).to have_css "svg"
  end

  it "renders the checbox with disabled status" do
    render_inline(described_class.new("some_attribute", disabled: true))

    expect(page).to have_css "input[type='checkbox'][name='some_attribute'][disabled]"
    expect(page).to have_css "svg"
  end
end
