class SalarySummary
  def initialize(relation)
    @relation = relation
  end

  def call
    rows = @relation.to_a
    salaries = rows.map(&:salary_cents).sort

    {
      headcount: rows.size,
      total_payroll_by_currency: sum_by(rows, :currency),
      average_salary_cents: average(salaries),
      median_salary_cents: median(salaries),
      minimum_salary_cents: salaries.first || 0,
      maximum_salary_cents: salaries.last || 0,
      by_country: grouped_average(rows, :country),
      by_department: grouped_average(rows, :department),
      by_level: grouped_average(rows, :level)
    }
  end

  private

  def sum_by(rows, field)
    rows.group_by { |employee| employee.public_send(field) }
      .transform_values { |group| group.sum(&:salary_cents) }
  end

  def grouped_average(rows, field)
    rows.group_by { |employee| employee.public_send(field) }
      .transform_values do |group|
        {
          headcount: group.size,
          average_salary_cents: average(group.map(&:salary_cents)),
          currency_mix: group.group_by(&:currency).transform_values(&:size)
        }
      end
  end

  def average(values)
    return 0 if values.empty?

    values.sum / values.size
  end

  def median(values)
    return 0 if values.empty?

    middle = values.size / 2
    values.size.odd? ? values[middle] : (values[middle - 1] + values[middle]) / 2
  end
end
