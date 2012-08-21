class DeleteAssessmentAppTables < ActiveRecord::Migration
  def up
    drop_table :company_assessments
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
