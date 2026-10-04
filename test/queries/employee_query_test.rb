require "test_helper"

class EmployeeQueryTest < ActiveSupport::TestCase
  test "filters and sorts employees" do
    product = create_employee(first_name: "Priya", last_name: "Rao", department: "Product", country: "India", currency: "INR", salary_cents: 9_000_000_00)
    create_employee(first_name: "Ada", last_name: "Smith", department: "Engineering", country: "United States", salary_cents: 150_000_00)

    result = EmployeeQuery.new(Employee.all, { department: "Product", country: "India", sort: "salary", direction: "desc" }).call

    assert_equal [product], result.to_a
  end
end
