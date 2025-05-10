module FormFieldHelpers
  def within_form_field(label, &block)
    within(:xpath, "//label[normalize-space(text())='#{label}']/ancestor::div[contains(@class, 'space-y-2')]", &block)
  end
end
