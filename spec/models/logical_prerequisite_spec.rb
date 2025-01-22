require 'rails_helper'

RSpec.describe LogicalPrerequisite, type: :model do
  describe 'associations' do
    it {
      should have_many(:operands_prerequisites)
        .class_name('Prerequisite')
        .with_foreign_key('parent_prerequisite_id')
        .dependent(:destroy)
        .inverse_of('parent_prerequisite')
    }
  end

  describe 'validations' do
    it {
      should validate_inclusion_of(:logical_operator)
        .in_array(["and", "or", "not", "at_least"])
        .with_message("#{Shoulda::Matchers::ExampleClass} is not a valid logical operator")
    }
  end
end
