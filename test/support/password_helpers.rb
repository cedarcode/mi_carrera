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

  def password_visibility_toggle_test_tailwind(label_text)
    container = find(:xpath, "//div[@data-controller='show-password'][.//label[text()='#{label_text}']]")

    within(container) do
      find("button[data-action='show-password#toggle']").click
      assert_selector "input[type='text']"
      find("button[data-action='show-password#toggle']").click
      assert_selector "input[type='password']"
    end
  end
end
