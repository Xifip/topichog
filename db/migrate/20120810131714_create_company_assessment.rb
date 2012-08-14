class CreateCompanyAssessment < ActiveRecord::Migration
  def change
    create_table :company_assessments do |t|
      t.string :company_name
      t.datetime :assessment_date
      t.text :description
      t.integer :company_id
      # market analysis
      #satisfaction
      t.decimal :ma_satisfaction
      t.integer :ma_satisfaction_count
      #impact
      t.decimal :ma_impact_high
      t.decimal :ma_impact_med
      t.decimal :ma_impact_low
      t.integer :ma_impact_count
      #urgency
      t.decimal :ma_urgency_high
      t.decimal :ma_urgency_med
      t.decimal :ma_urgency_low
      t.integer :ma_urgency_count
      #tasks
      t.decimal :ma_tasks_research
      t.decimal :ma_tasks_segmentation
      t.decimal :ma_tasks_customer_analysis
      t.decimal :ma_tasks_swot
      # Add fields that let Rails automatically keep track
      # of when movies are added or modified:
      t.timestamps
    end
    add_index :company_assessments, [:company_id, :created_at]
  end
end