module EmployeeFactory
  def create_employee(attributes = {})
    defaults = {
      employee_number: "ACME-#{SecureRandom.hex(4)}",
      first_name: "Ada",
      last_name: "Lovelace",
      email: "ada-#{SecureRandom.hex(4)}@acme.example",
      country: "United States",
      city: "New York",
      department: "Engineering",
      level: "L4",
      employment_status: "Active",
      currency: "USD",
      salary_cents: 125_000_00,
      hire_date: Date.new(2020, 1, 15)
    }

    Employee.create!(defaults.merge(attributes))
  end
end
