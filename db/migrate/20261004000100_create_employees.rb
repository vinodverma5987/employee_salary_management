class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :employee_number, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :country, null: false
      t.string :city, null: false
      t.string :department, null: false
      t.string :level, null: false
      t.string :employment_status, null: false
      t.string :currency, null: false
      t.integer :salary_cents, null: false
      t.date :hire_date, null: false

      t.timestamps
    end

    add_index :employees, :employee_number, unique: true
    add_index :employees, :email, unique: true
    add_index :employees, :country
    add_index :employees, :department
    add_index :employees, :level
    add_index :employees, :employment_status
    add_index :employees, :salary_cents
  end
end
