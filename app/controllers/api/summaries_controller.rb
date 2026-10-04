module Api
  class SummariesController < ApplicationController
    def show
      relation = EmployeeQuery.new(Employee.all, filter_params).call
      render json: SalarySummary.new(relation).call
    end

    private

    def filter_params
      params.permit(:q, :country, :department, :level, :employment_status, :sort, :direction)
    end
  end
end
