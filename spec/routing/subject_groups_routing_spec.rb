require 'rails_helper'

RSpec.describe "routes for subject_groups", type: :routing do
  it "routes a numeric id to subject_groups#show" do
    expect(get: "/grupos/42").to route_to(controller: "subject_groups", action: "show", id: "42")
  end

  it "does not route a non-numeric id" do
    expect(get: "/grupos/choices.js").not_to be_routable
  end
end
