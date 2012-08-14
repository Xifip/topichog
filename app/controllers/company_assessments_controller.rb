class CompanyAssessmentsController < ApplicationController
  def index
    #debugger
    @company_results = CompanyAssessment.all
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @company_result = CompanyAssessment.find(id) # look up movie by unique ID
    gon.company_result = @company_result    
    gon.ma_satisfaction = [['satisfied', (@company_result.ma_satisfaction).to_f*100],['not satisfied', (1-@company_result.ma_satisfaction).to_f*100]]
    gon.ma_impact = [
      ['High negative impact', (@company_result.ma_impact_high).to_f*100],
      ['Medium negative impact', (@company_result.ma_impact_med).to_f*100], 
      ['Low negative impact', (@company_result.ma_impact_low).to_f*100]
    ]
    
    filler = 3
  end

  def new
   
  end
end
