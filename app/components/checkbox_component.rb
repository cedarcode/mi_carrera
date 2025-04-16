# frozen_string_literal: true

class CheckboxComponent < ViewComponent::Base
  def initialize(form:, id:, object_name:, checked:, disabled:, data:)
    @form = form
    @id = id
    @object_name = object_name
    @checked = checked
    @disabled = disabled
    @data = data
  end

  attr_reader :form, :id, :object_name, :checked, :disabled, :data
end
