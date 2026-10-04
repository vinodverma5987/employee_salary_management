require "test_helper"

class ApiEmployeesControllerTest < ActionDispatch::IntegrationTest
  test "lists employees with pagination metadata" do
    create_employee(first_name: "Ada", last_name: "Lovelace")

    get api_employees_path

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.fetch("employees").size
    assert_equal 1, body.fetch("pagination").fetch("total")
  end

  test "updates salary through API" do
    employee = create_employee(salary_cents: 100_000_00)

    patch salary_api_employee_path(employee), params: {
      salary_update: {
        salary_cents: 115_000_00,
        effective_on: "2026-02-01",
        reason: "Market adjustment"
      }
    }

    assert_response :success
    assert_equal 115_000_00, employee.reload.salary_cents
    assert_equal "Market adjustment", employee.salary_changes.last.reason
  end
end
