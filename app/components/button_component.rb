class ButtonComponent < ViewComponent::Base
  attr_reader :form, :label

  def initialize(form:, label:)
    @form = form
    @label = label
  end

  def call
    klass = 'bg-primary text-white font-bold shadow-sm cursor-pointer p-2 rounded-md'

    @form.button @label, class: klass
  end
end
