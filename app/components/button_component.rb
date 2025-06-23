class ButtonComponent < ViewComponent::Base
  attr_reader :form, :label

  def initialize(form:, label:)
    @form = form
    @label = label
  end

  def call
    klass = 'bg-primary text-white font-bold shadow-sm cursor-pointer p-2 rounded-md ' \
            'disabled:opacity-50 disabled:cursor-not-allowed hover:bg-violet-500 ' \
            'focus:outline-2 focus:outline-offset-2 focus:outline-indigo-600'

    @form.submit @label, class: klass
  end
end
