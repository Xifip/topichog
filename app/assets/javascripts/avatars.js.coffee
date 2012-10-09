# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  new AvatarCropper()
  $("#avatar_image").change ->
      $('form.edit_avatar').submit()
  new AvatarCropper()

class AvatarCropper
  constructor: ->
    $('#avatar_cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 200, 200]
      onChange: @update
      onSelect: @update
  
  update: (coords) =>
    $('#avatar_crop_x').val(coords.x)
    $('#avatar_crop_y').val(coords.y)
    $('#avatar_crop_w').val(coords.w)
    $('#avatar_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
          $('#preview').css
                  width: Math.round(100/coords.w * $('#avatar_cropbox').width()) + 'px'
                  height: Math.round(100/coords.h * $('#avatar_cropbox').height()) + 'px'
                  marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
                  marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'  
