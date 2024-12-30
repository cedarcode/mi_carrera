module PasswordHelpers
  def password_visibility_toggle_test(container_id)
    within(container_id) do
      find(".show-password-button").click
      assert_selector "input[type='text']"
      find(".show-password-button").click
      assert_selector "input[type='password']"
    end
  end
end
