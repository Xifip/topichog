# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# this seems to be causing a problem in asset pipeline. When using require tree
# the static_pages.js.coffee trips up on loading jquery, indicating that there is
# some error in this library ( I identified this one by trial and error) see

# http://stackoverflow.com/questions/5263385/jquery-multiple-document-ready

# "It is important to note that each jQuery() call must actually return. If an 
# exception is thrown in one, subsequent (unrelated) calls will never be executed.
# This applies regardless of syntax. You can use jQuery(), jQuery(fuction() {}), 
# $(document).ready(), whatever you like, the behavior is the same. If an early 
# one fails, subsequent blocks will never be run.
# This was a problem for me when using 3rd-party libraries. One library was throwing 
# an exception, and subsequent libraries never initialized anything."

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



