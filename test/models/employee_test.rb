require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "salary update changes current salary and records immutable history" do
    employee = create_employee(salary_cents: 100_000_00)

    assert_difference -> { employee.salary_changes.count }, 1 do
      employee.update_salary!(
        new_salary_cents: 112_500_00,
        effective_on: Date.new(2026, 1, 1),
        reason: "Annual compensation cycle"
      )
    end

    employee.reload
    change = employee.salary_changes.last

    assert_equal 112_500_00, employee.salary_cents
    assert_equal 100_000_00, change.previous_salary_cents
    assert_equal 112_500_00, change.new_salary_cents
    assert_equal "Annual compensation cycle", change.reason
  end

  test "search finds employees by email and employee number" do
    target = create_employee(employee_number: "ACME-77777", email: "target@acme.example")
    create_employee(employee_number: "ACME-88888", email: "other@acme.example")

    assert_equal [target], Employee.search("77777").to_a
    assert_equal [target], Employee.search("target@").to_a
  end
end
