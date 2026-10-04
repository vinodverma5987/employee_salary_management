class CreateSalaryChanges < ActiveRecord::Migration[8.1]
  def change
    create_table :salary_changes do |t|
      t.references :employee, null: false, foreign_key: true
      t.integer :previous_salary_cents
      t.integer :new_salary_cents, null: false
      t.string :currency, null: false
      t.date :effective_on, null: false
      t.string :reason, null: false

      t.timestamps
    end

    add_index :salary_changes, [:employee_id, :effective_on]
  end
end
