# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  
  $("table tr td").css("color", "red")
  #$("#chartdiv").text(#{@company_result.company_name})
  #$.jqplot('chartdiv',  [[[1, 2],[3,5.12],[5,13.1],[7,33.6],[9,85.9],[11,219.9]]])
 
  #alert gon.ma_satisfaction
  #alert data
  $.jqplot('satisfactiondiv', [gon.ma_satisfaction],  { seriesDefaults: { renderer:$.jqplot.PieRenderer, rendererOptions:{ showDataLabels: true, startAngle: -300}}, legend: { show:true, location: 's' }})
  $.jqplot('impactdiv', [gon.ma_impact],  { seriesDefaults: { renderer:$.jqplot.PieRenderer, rendererOptions:{ showDataLabels: true, startAngle: -300}}, legend: { show:true, location: 's' }})
  #alert gon.company_result.company_name if gon
