class EmployeeQuery
  SORTS = {
    "name" => "last_name",
    "department" => "department",
    "country" => "country",
    "level" => "level",
    "salary" => "salary_cents",
    "hire_date" => "hire_date"
  }.freeze

  def initialize(relation = Employee.all, params = {})
    @relation = relation
    @params = params
  end

  def call
    filtered = @relation
      .search(@params[:q])
      .then { |scope| filter(scope, :country) }
      .then { |scope| filter(scope, :department) }
      .then { |scope| filter(scope, :level) }
      .then { |scope| filter(scope, :employment_status) }

    filtered.order(order_clause)
  end

  private

  def filter(scope, field)
    value = @params[field]
    value.present? ? scope.where(field => value) : scope
  end

  def order_clause
    column = SORTS.fetch(@params[:sort].to_s, "last_name")
    direction = @params[:direction] == "desc" ? "desc" : "asc"
    Arel.sql("#{column} #{direction}")
  end
end
