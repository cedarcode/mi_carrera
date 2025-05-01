# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMenuComponent, type: :component do
  include Rails.application.routes.url_helpers

  describe "#initialize" do
    context "when current_user is provided" do
      let(:current_user) { create(:user) }
      let(:component) { described_class.new(current_user: current_user) }

      it "assigns the current_user" do
        expect(component.current_user).to eq(current_user)
      end
    end
  end

  context "when current_user is not provided" do
    let(:component) { described_class.new(current_user: nil) }

    it "assigns current_user to nil" do
      expect(component.current_user).to be_nil
    end
  end

  describe "#render" do
    context "when current_user is provided" do
      let(:current_user) { create(:user, email: "test@example.com") }
      let(:component) { described_class.new(current_user: current_user) }

      it "renders the user menu with the user's initial and email" do
        render_inline(component)

        expect(page).to have_text("T")
        expect(page).to have_text("test@example.com")
        expect(page).to have_link("Editar Perfil", href: edit_user_registration_path)
        expect(page).to have_link("Salir", href: destroy_user_session_path)
      end
    end

    context "when current_user is not provided" do
      let(:component) { described_class.new(current_user: nil) }

      it "renders the user menu with a generic avatar and login link" do
        render_inline(component)
        expect(page).to have_link("Ingresar", href: new_user_session_path)
        expect(page).not_to have_text("Editar Perfil")
        expect(page).not_to have_text("Salir")
      end
    end
  end
end
