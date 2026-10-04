module Api
  class OptionsController < ApplicationController
    def show
      render json: {
        countries: Employee::COUNTRIES.keys,
        departments: Employee::DEPARTMENTS,
        levels: Employee::LEVELS,
        statuses: Employee::STATUSES
      }
    end
  end
end
