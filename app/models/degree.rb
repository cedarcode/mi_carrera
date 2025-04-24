class Degree < ApplicationRecord
  after_create :create_tenant

  validates :key, presence: true, uniqueness: true

  def create_tenant
    Apartment::Tenant.create(key)
  end
end
