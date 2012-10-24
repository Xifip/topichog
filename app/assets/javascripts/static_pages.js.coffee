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
    $("#cases").addClass "learn-more-section-spacer"
    $("#features").removeClass "learn-more-section-spacer"
    $("#about").removeClass "learn-more-section-spacer"
    $("#pricing").removeClass "learn-more-section-spacer"    
    $("#student-case").removeClass "learn-more-section-spacer"
    $("#jobseeker-case").removeClass "learn-more-section-spacer"
  $("#features-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"
    $(this).find("i").addClass "icon-white"
    $("#cases-tab a i").removeClass "icon-white"                          
    $("#about-tab a i").removeClass "icon-white"        
    $("#pricing-tab a i").removeClass "icon-white" 
    $("#features").addClass "learn-more-section-spacer"
    $("#cases").removeClass "learn-more-section-spacer"
    $("#about").removeClass "learn-more-section-spacer"
    $("#pricing").removeClass "learn-more-section-spacer"
    $("#student-case").removeClass "learn-more-section-spacer"
    $("#jobseeker-case").removeClass "learn-more-section-spacer"    
  $("#pricing-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"
    $(this).find("i").addClass "icon-white"
    $("#cases-tab a i").removeClass "icon-white"                          
    $("#features-tab a i").removeClass "icon-white"        
    $("#about-tab a i").removeClass "icon-white"
    $("#pricing").addClass "learn-more-section-spacer"
    $("#features").removeClass "learn-more-section-spacer"
    $("#about").removeClass "learn-more-section-spacer"
    $("#cases").removeClass "learn-more-section-spacer"
    $("#student-case").removeClass "learn-more-section-spacer"
    $("#jobseeker-case").removeClass "learn-more-section-spacer"               
  $("#about-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"
    $(this).find("i").addClass "icon-white"
    $("#cases-tab a i").removeClass "icon-white"                          
    $("#features-tab a i").removeClass "icon-white"        
    $("#pricing-tab a i").removeClass "icon-white" 
    $("#about").addClass "learn-more-section-spacer"
    $("#features").removeClass "learn-more-section-spacer"
    $("#pricing").removeClass "learn-more-section-spacer"
    $("#cases").removeClass "learn-more-section-spacer"
    $("#student-case").removeClass "learn-more-section-spacer"
    $("#jobseeker-case").removeClass "learn-more-section-spacer"            
  $("#student-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"    
    $("#about").removeClass "learn-more-section-spacer"
    $("#features").removeClass "learn-more-section-spacer"
    $("#pricing").removeClass "learn-more-section-spacer"
    $("#cases").removeClass "learn-more-section-spacer"
    $("#student-case").addClass "learn-more-section-spacer"
    $("#jobseeker-case").removeClass "learn-more-section-spacer"        
  $("#professional-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show" 
  $("#jobseeker-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"
    $("#about").removeClass "learn-more-section-spacer"
    $("#features").removeClass "learn-more-section-spacer"
    $("#pricing").removeClass "learn-more-section-spacer"
    $("#cases").removeClass "learn-more-section-spacer"
    $("#student-case").removeClass "learn-more-section-spacer"
    $("#jobseeker-case").addClass "learn-more-section-spacer"      
  $("#company-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show" 
  $("#institution-case-tab a").click (e) ->
    #e.preventDefault()
    $(this).tab "show"                 
