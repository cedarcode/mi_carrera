module PasswordHelpers
  def password_visibility_toggle_test(label_text)
    container = find("li", text: label_text, match: :prefer_exact)

    within(container) do
      find(".show-password-button").click
      assert_selector "input[type='text']"
      find(".show-password-button").click
      assert_selector "input[type='password']"
    end
  end
end
