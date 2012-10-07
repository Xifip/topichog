# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#tag_name').autocomplete
    source: $('#tag_name').data('autocomplete-source')
    select: (event, ui) -> 
      add_to_filter(ui.item.value)    

  $("#tags_remove a").click (event) ->
    id_string = '#' + $(this).attr('id').split('_')[0]
    $(id_string).val('')
    $('#tags_filter_list').submit()
    event.preventDefault() # Prevent link from following its href
  $("#tags_remove a").hover (->
    $(this).addClass "hover-tag-remove"
  ), ->
    $(this).removeClass "hover-tag-remove"
  $("#tags_remove a").each (->
    if $(this).text() != ''
      $(this).addClass "label label-info"
      $('#results_count').removeClass('hide')
  )
  $("#popular_tags a").click (event) ->
    add_to_filter($(this).text())
    event.preventDefault()
  
  add_to_filter = (filter_text) ->
    current_tag_filters = []
    current_tag_filters[0] = $('#tag1_remove').text()
    current_tag_filters[1] = $('#tag2_remove').text()
    current_tag_filters[2] = $('#tag3_remove').text()  
    current_tag_filters[3] = $('#tag4_remove').text()
    current_tag_filters[4] = $('#tag5_remove').text() 
    next_filter = false
    i = 0
    while i < current_tag_filters.length and next_filter is false
      if current_tag_filters[i] is ""
        next_filter = true
        current_tag_filters[i] = filter_text
      i++
    $('#tag1_remove').text(current_tag_filters[0])
    $('#tag2_remove').text(current_tag_filters[1])
    $('#tag3_remove').text(current_tag_filters[2])  
    $('#tag4_remove').text(current_tag_filters[3])
    $('#tag5_remove').text(current_tag_filters[4])
    $('#tag1').val(current_tag_filters[0])
    $('#tag2').val(current_tag_filters[1])
    $('#tag3').val(current_tag_filters[2])
    $('#tag4').val(current_tag_filters[3])
    $('#tag5').val(current_tag_filters[4])
    $('#tags_filter_list').submit()    
