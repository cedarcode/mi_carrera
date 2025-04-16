# frozen_string_literal: true

class ListItemComponent < ViewComponent::Base
  renders_one :trailing_icon

  def initialize(text:, link: nil)
    @text = text
    @link = link
  end

  attr_reader :text, :link
end
