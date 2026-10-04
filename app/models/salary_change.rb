class SalaryChange < ApplicationRecord
  belongs_to :employee

  validates :new_salary_cents, numericality: { greater_than: 0, only_integer: true }
  validates :currency, :effective_on, :reason, presence: true
end
