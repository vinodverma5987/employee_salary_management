return if Employee.count == 10_000

SalaryChange.delete_all
Employee.delete_all

first_names = %w[Aarav Ada Amelia Anika Arjun Carlos Chen David Elena Fatima Grace Hannah Hiro Ingrid Jamal Kavya Liam Mei Noah Olivia Priya Rafael Sofia Theo Uma Vera Wei Yara Zoe]
last_names = %w[Anderson Banerjee Brown Chen Das Evans Garcia Gupta Johnson Kapoor Khan Kim Lee Miller Nguyen Patel Rao Robinson Schmidt Sharma Singh Smith Taylor Thomas Verma Williams Wilson]
base_by_level = {
  "L1" => 55_000,
  "L2" => 75_000,
  "L3" => 98_000,
  "L4" => 130_000,
  "L5" => 165_000,
  "L6" => 210_000,
  "Executive" => 310_000
}
currency_multiplier = {
  "USD" => 1.0,
  "INR" => 83.0,
  "GBP" => 0.78,
  "EUR" => 0.92,
  "CAD" => 1.35,
  "AUD" => 1.52
}

employees = []
salary_changes = []
now = Time.current

10_000.times do |index|
  country = Employee::COUNTRIES.keys[index % Employee::COUNTRIES.size]
  country_config = Employee::COUNTRIES.fetch(country)
  currency = country_config.fetch(:currency)
  level = Employee::LEVELS[(index / 7) % Employee::LEVELS.size]
  department = Employee::DEPARTMENTS[(index / 11) % Employee::DEPARTMENTS.size]
  status = index % 37 == 0 ? "On Leave" : (index % 97 == 0 ? "Departed" : "Active")
  first_name = first_names[index % first_names.size]
  last_name = last_names[(index / first_names.size) % last_names.size]
  salary = ((base_by_level.fetch(level) + (index % 29) * 1_750 + Employee::DEPARTMENTS.index(department) * 2_250) * currency_multiplier.fetch(currency)).round

  employees << {
    employee_number: "ACME-%05d" % (index + 1),
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}.#{index + 1}@acme.example",
    country: country,
    city: country_config.fetch(:cities)[index % country_config.fetch(:cities).size],
    department: department,
    level: level,
    employment_status: status,
    currency: currency,
    salary_cents: salary * 100,
    hire_date: Date.new(2015, 1, 1) + (index % 3_200).days,
    created_at: now,
    updated_at: now
  }
end

Employee.insert_all!(employees)

Employee.find_each do |employee|
  salary_changes << {
    employee_id: employee.id,
    previous_salary_cents: nil,
    new_salary_cents: employee.salary_cents,
    currency: employee.currency,
    effective_on: employee.hire_date,
    reason: "Initial salary seed",
    created_at: now,
    updated_at: now
  }
end

SalaryChange.insert_all!(salary_changes)

puts "Seeded #{Employee.count} employees and #{SalaryChange.count} salary history records."
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
