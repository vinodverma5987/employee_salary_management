module Api
  class EmployeesController < ApplicationController
    protect_from_forgery with: :null_session

    def index
      employees = EmployeeQuery.new(Employee.all, filter_params).call
      page = [params.fetch(:page, 1).to_i, 1].max
      per_page = params.fetch(:per_page, 25).to_i.clamp(10, 100)
      total = employees.count

      render json: {
        employees: employees.offset((page - 1) * per_page).limit(per_page).map { |employee| employee_payload(employee) },
        pagination: {
          page: page,
          per_page: per_page,
          total: total,
          total_pages: (total.to_f / per_page).ceil
        }
      }
    end

    def show
      employee = Employee.includes(:salary_changes).find(params[:id])

      render json: employee_payload(employee).merge(
        salary_changes: employee.salary_changes.order(effective_on: :desc).map { |change| salary_change_payload(change) }
      )
    end

    def update_salary
      employee = Employee.find(params[:id])
      employee.update_salary!(
        new_salary_cents: salary_params.fetch(:salary_cents).to_i,
        effective_on: Date.iso8601(salary_params.fetch(:effective_on)),
        reason: salary_params.fetch(:reason)
      )

      render json: employee_payload(employee.reload), status: :ok
    rescue ActiveRecord::RecordInvalid, KeyError, Date::Error => error
      render json: { error: error.message }, status: :unprocessable_entity
    end

    private

    def filter_params
      params.permit(:q, :country, :department, :level, :employment_status, :sort, :direction)
    end

    def salary_params
      params.require(:salary_update).permit(:salary_cents, :effective_on, :reason)
    end

    def employee_payload(employee)
      {
        id: employee.id,
        employee_number: employee.employee_number,
        full_name: employee.full_name,
        first_name: employee.first_name,
        last_name: employee.last_name,
        email: employee.email,
        country: employee.country,
        city: employee.city,
        department: employee.department,
        level: employee.level,
        employment_status: employee.employment_status,
        currency: employee.currency,
        salary_cents: employee.salary_cents,
        hire_date: employee.hire_date
      }
    end

    def salary_change_payload(change)
      {
        id: change.id,
        previous_salary_cents: change.previous_salary_cents,
        new_salary_cents: change.new_salary_cents,
        currency: change.currency,
        effective_on: change.effective_on,
        reason: change.reason,
        created_at: change.created_at
      }
    end
  end
end
