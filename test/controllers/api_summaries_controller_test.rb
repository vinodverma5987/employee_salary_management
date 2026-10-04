require "test_helper"

class ApiSummariesControllerTest < ActionDispatch::IntegrationTest
  test "returns filtered summary" do
    create_employee(country: "United States", salary_cents: 100_000_00)
    create_employee(country: "India", currency: "INR", salary_cents: 8_000_000_00)

    get api_summary_path(country: "United States")

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.fetch("headcount")
    assert_equal 100_000_00, body.fetch("total_payroll_by_currency").fetch("USD")
  end
end
