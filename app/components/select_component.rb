# frozen_string_literal: true

class SelectComponent < ViewComponent::Base
  attr_reader :form, :field, :options, :html_options

  def initialize(form:, field:, options:, html_options: {})
    @form = form
    @field = field
    @options = options
    @html_options = html_options
  end

  private

  def default_classes
    'w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 truncate'
  end

  def merged_html_options
    html_options.merge(
      class: [default_classes, html_options[:class]].compact.join(' ')
    )
  end
end
