# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  CKEDITOR.replace "reference_textarea",
    extraPlugins: "autogrow"
    autoGrow_minHeight: 50
    toolbar: "RefToolbar"    
    # Remove the Resize plugin as it does not make sense to use it in conjunction with the AutoGrow plugin.
    removePlugins: "resize"
  CKEDITOR.replace "content_textarea",
    extraPlugins: "autogrow"
    autoGrow_minHeight: 500
    toolbar: "ContentToolbar"
    # Remove the Resize plugin as it does not make sense to use it in conjunction with the AutoGrow plugin.
    removePlugins: "resize"



