module PasswordHelpers
  def password_visibility_toggle_test(label_text)
    toggle = find_field(label_text).sibling("button[data-action='show-password#toggle']")

    toggle.click
    assert has_field?(label_text, type: 'text')
    toggle.click
    assert has_field?(label_text, type: 'password')
  end
end
