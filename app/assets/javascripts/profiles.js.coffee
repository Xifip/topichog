# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.best_in_place').best_in_place()
  handler = ->
    $(".edit_bio_col textarea").charCount
      allowed: 1000
      warning: 50
      counterText: "Characters left: "


  $("#edit_bio").bind "click", handler
  $(".best_in_place").bind "ajax:success", ->
    $("#edit_bio").unbind "click", handler


