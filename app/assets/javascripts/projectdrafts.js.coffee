# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  
  #default usage
  $("#projectdraft_title").charCount
    allowed: 30
    warning: 20
    counterText: "Characters left: "  
  #custom usage
  $("#projectdraft_summary").charCount
    allowed: 140
    warning: 120
    counterText: "Characters left: "
