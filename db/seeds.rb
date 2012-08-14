# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#seed the company assessements table with some assessment results
CompanyAssessment.delete_all

more_results = [  
  {
  company_name: 'a_company',
  assessment_date: '01/06/2010',
  description:  'IT firm',
  company_id: '1',
  ma_satisfaction:  '0.8',
  ma_satisfaction_count:  '16',
  ma_impact_high: '0.2',
  ma_impact_med:  '0.4',
  ma_impact_low:  '0.4',
  ma_impact_count:  '12',
  ma_urgency_high:  '0.5',
  ma_urgency_med: '0.2',
  ma_urgency_low: '0.3',
  ma_urgency_count: '12',
  ma_tasks_research:  '0.8',
  ma_tasks_segmentation:  '0.6',
  ma_tasks_customer_analysis: '0.2',
  ma_tasks_swot:  '0.3',
  created_at: '1/1/2001'
  },
  {
  company_name: 'b_company',
  assessment_date: '01/06/2010',
  description:  'Food firm',
  company_id: '2',
  ma_satisfaction:  '0.5',
  ma_satisfaction_count:  '12',
  ma_impact_high: '0.6',
  ma_impact_med:  '0.2',
  ma_impact_low:  '0.2',
  ma_impact_count:  '10',
  ma_urgency_high:  '0.3',
  ma_urgency_med: '0.3',
  ma_urgency_low: '0.2',
  ma_urgency_count: '10',
  ma_tasks_research:  '0.6',
  ma_tasks_segmentation:  '0.6',
  ma_tasks_customer_analysis: '0.2',
  ma_tasks_swot:  '0.7',
  created_at: '1/1/2011'
  }    
]

more_results.each do |result|
  CompanyAssessment.create!(result)
end