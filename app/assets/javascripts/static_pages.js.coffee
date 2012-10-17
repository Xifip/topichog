# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# see comment on project.js.coffee
###
jQuery ->
  $("#nav-left li a").hover (->
    $(this).find('i').addClass "icon-white"
  ), ->
    $(this).find('i').removeClass "icon-white"
###
jQuery ->
  $("#cases-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"
    $(this).find("i").addClass "icon-white"
    $("#about-tab a i").removeClass "icon-white"                          
    $("#features-tab a i").removeClass "icon-white"        
    $("#pricing-tab a i").removeClass "icon-white" 
  $("#features-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"
    $(this).find("i").addClass "icon-white"
    $("#cases-tab a i").removeClass "icon-white"                          
    $("#about-tab a i").removeClass "icon-white"        
    $("#pricing-tab a i").removeClass "icon-white" 
  $("#pricing-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"
    $(this).find("i").addClass "icon-white"
    $("#cases-tab a i").removeClass "icon-white"                          
    $("#features-tab a i").removeClass "icon-white"        
    $("#about-tab a i").removeClass "icon-white"     
  $("#about-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"
    $(this).find("i").addClass "icon-white"
    $("#cases-tab a i").removeClass "icon-white"                          
    $("#features-tab a i").removeClass "icon-white"        
    $("#pricing-tab a i").removeClass "icon-white" 
  $("#student-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"    
  $("#professional-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show" 
  $("#jobseeker-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show" 
  $("#company-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show" 
  $("#institution-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"                 
