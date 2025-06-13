module FormFieldHelper
  def within_form_field(label, &block)
    within(:xpath, "//label[normalize-space(text())='#{label}']/parent::*/parent::*", &block)
  end
end
