class CompanyAssessment < ActiveRecord::Base
  attr_accessible   :company_name,
  :assessment_date, 
  :description, 
  :company_id, 
  :ma_satisfaction, 
  :ma_satisfaction_count,
  :ma_impact_high,
  :ma_impact_med,
  :ma_impact_low,
  :ma_impact_count,
  :ma_urgency_high,
  :ma_urgency_med,
  :ma_urgency_low,
  :ma_urgency_count,
  :ma_tasks_research,
  :ma_tasks_segmentation,
  :ma_tasks_customer_analysis,
  :ma_tasks_swot,
  :created_at

end
