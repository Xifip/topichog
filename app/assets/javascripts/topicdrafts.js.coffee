# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $("#topicdraft_title").watermark "Topic title..."  
  $("#topicdraft_summary").watermark "Topic summary..."  
  $("#topicdraft_tag_list").watermark "Comma separated tags..."  
  $("#topicdraft_tag_list").tagsInput autocomplete_url: $('#topicdraft_tag_list').data('autocomplete-source')
  #default usage
  $("#topicdraft_title").charCount
    allowed: 30
    warning: 20
    counterText: "Characters left: "  
  #custom usage
  $("#topicdraft_summary").charCount
    allowed: 140
    warning: 120
    counterText: "Characters left: "

    
