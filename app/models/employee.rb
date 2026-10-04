class Employee < ApplicationRecord
  COUNTRIES = {
    "United States" => { currency: "USD", cities: ["New York", "Austin", "Seattle", "Chicago"] },
    "India" => { currency: "INR", cities: ["Bengaluru", "Mumbai", "Hyderabad", "Pune"] },
    "United Kingdom" => { currency: "GBP", cities: ["London", "Manchester", "Bristol", "Edinburgh"] },
    "Germany" => { currency: "EUR", cities: ["Berlin", "Munich", "Hamburg", "Frankfurt"] },
    "Canada" => { currency: "CAD", cities: ["Toronto", "Vancouver", "Montreal", "Calgary"] },
    "Australia" => { currency: "AUD", cities: ["Sydney", "Melbourne", "Brisbane", "Perth"] }
  }.freeze

  DEPARTMENTS = ["Engineering", "Sales", "Marketing", "Finance", "People", "Operations", "Support", "Product"].freeze
  LEVELS = ["L1", "L2", "L3", "L4", "L5", "L6", "Executive"].freeze
  STATUSES = ["Active", "On Leave", "Departed"].freeze

  has_many :salary_changes, dependent: :destroy

  validates :employee_number, :first_name, :last_name, :email, :country, :city, :department,
    :level, :employment_status, :currency, :salary_cents, :hire_date, presence: true
  validates :employee_number, :email, uniqueness: true
  validates :salary_cents, numericality: { greater_than: 0, only_integer: true }
  validates :country, inclusion: { in: COUNTRIES.keys }
  validates :department, inclusion: { in: DEPARTMENTS }
  validates :level, inclusion: { in: LEVELS }
  validates :employment_status, inclusion: { in: STATUSES }

  scope :search, ->(term) {
    next all if term.blank?

    pattern = "%#{sanitize_sql_like(term.strip.downcase)}%"
    where(
      "lower(first_name) LIKE :pattern OR lower(last_name) LIKE :pattern OR lower(email) LIKE :pattern OR lower(employee_number) LIKE :pattern",
      pattern: pattern
    )
  }

  def full_name
    "#{first_name} #{last_name}"
  end

  def update_salary!(new_salary_cents:, effective_on:, reason:)
    transaction do
      salary_changes.create!(
        previous_salary_cents: salary_cents,
        new_salary_cents: new_salary_cents,
        currency: currency,
        effective_on: effective_on,
        reason: reason
      )
      update!(salary_cents: new_salary_cents)
    end
  end
end
