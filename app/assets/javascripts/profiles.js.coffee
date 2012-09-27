# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $("#profile_image").change ->
      $('form.edit_profile').submit()  
  new AvatarCropper()

class AvatarCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 200, 200]
      onChange: @update
      onSelect: @update
  
  update: (coords) =>
    $('#profile_crop_x').val(coords.x)
    $('#profile_crop_y').val(coords.y)
    $('#profile_crop_w').val(coords.w)
    $('#profile_crop_h').val(coords.h)

  
