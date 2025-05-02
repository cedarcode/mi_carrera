class Degree < ApplicationRecord
  after_create :create_tenant

  has_many :users, dependent: :nullify

  validates :key, presence: true, uniqueness: true

  def create_tenant
    Apartment::Tenant.create(key)
  end
end
