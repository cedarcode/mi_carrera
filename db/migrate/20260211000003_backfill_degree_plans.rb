class BackfillDegreePlans < ActiveRecord::Migration[8.1]
  def up
    # 1. Create a DegreePlan for each Degree using its current_plan as name
    execute <<~SQL
      INSERT INTO degree_plans (degree_id, name, created_at, updated_at)
      SELECT id, current_plan, NOW(), NOW()
      FROM degrees
    SQL

    # 2. Set degree_plan_id on subjects based on their degree_id
    execute <<~SQL
      UPDATE subjects
      SET degree_plan_id = degree_plans.id
      FROM degree_plans
      WHERE degree_plans.degree_id = subjects.degree_id
    SQL

    # 3. Set degree_plan_id on subject_groups based on their degree_id
    execute <<~SQL
      UPDATE subject_groups
      SET degree_plan_id = degree_plans.id
      FROM degree_plans
      WHERE degree_plans.degree_id = subject_groups.degree_id
    SQL

    # 4. Set degree_plan_id on users based on their degree_id
    execute <<~SQL
      UPDATE users
      SET degree_plan_id = degree_plans.id
      FROM degree_plans
      WHERE degree_plans.degree_id = users.degree_id
    SQL

    # 5. Make degree_plan_id NOT NULL
    change_column_null :subjects, :degree_plan_id, false
    change_column_null :subject_groups, :degree_plan_id, false
    change_column_null :users, :degree_plan_id, false
  end

  def down
    change_column_null :subjects, :degree_plan_id, true
    change_column_null :subject_groups, :degree_plan_id, true
    change_column_null :users, :degree_plan_id, true
  end
end
