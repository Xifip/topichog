# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if ($("#user_topic_posts li").length is 0) and ($("#user_topic_posts li").length is 0)
    $("#projecttip").popover "show"
  else
    $("#projecttip").popover()
  if ($("#user_topic_posts li").length is 0) and ($("#user_topic_posts li").length is 0)
    $("#topictip").popover "show"
  else
    $("#topictip").popover()  
  if ($('#user_bio').text().trim().length is 0)
    $("#biotip").removeClass("hide")
    $("#biotip").popover "show"
  else
    $("#biotip").popover()  
# manage close and open of project tooltip
  $("#close-project-popover").click ->
    $("#projecttip").popover "hide"
  $("#projecttip i").click ->
    $("#projecttip").popover "show"    
    $("#close-project-popover").click ->
      $("#projecttip").popover "hide"  
# manage close and open of topic tooltip        
  $("#close-topic-popover").click ->
    $("#topictip").popover "hide"
  $("#topictip i").click ->
    $("#topictip").popover "show"    
    $("#close-topic-popover").click ->
      $("#topictip").popover "hide"  
# manage close and open of bio tooltip        
  $("#close-bio-popover").click ->
    $("#biotip").popover "hide"
  $("#biotip i").click ->
    $("#biotip").popover "show"    
    $("#close-bio-popover").click ->
      $("#biotip").popover "hide"        
