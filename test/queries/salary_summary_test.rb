require "test_helper"

class SalarySummaryTest < ActiveSupport::TestCase
  test "calculates payroll and salary statistics" do
    create_employee(department: "Engineering", salary_cents: 100_000_00)
    create_employee(department: "Engineering", salary_cents: 140_000_00)
    create_employee(department: "Finance", salary_cents: 90_000_00)

    summary = SalarySummary.new(Employee.all).call

    assert_equal 3, summary.fetch(:headcount)
    assert_equal 330_000_00, summary.fetch(:total_payroll_by_currency).fetch("USD")
    assert_equal 100_000_00, summary.fetch(:median_salary_cents)
    assert_equal 110_000_00, summary.fetch(:average_salary_cents)
    assert_equal 2, summary.fetch(:by_department).fetch("Engineering").fetch(:headcount)
  end
end
