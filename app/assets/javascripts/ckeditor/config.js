
/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.editorConfig = function( config )
{
// Define changes to default configuration here. For example:
// config.language = 'fr';
// config.uiColor = '#AADC6E';
/* Filebrowser routes */
// The location of an external file browser, that should be launched when "Browse Server" button is pressed.
config.filebrowserBrowseUrl = "/ckeditor/attachment_files";
// The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";
// The location of a script that handles file uploads in the Flash dialog.
config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";
// The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";
// The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
config.filebrowserImageBrowseUrl = "/ckeditor/pictures";
// The location of a script that handles file uploads in the Image dialog.
config.filebrowserImageUploadUrl = "/ckeditor/pictures";
// The location of a script that handles file uploads.
config.filebrowserUploadUrl = "/ckeditor/attachment_files";
// Rails CSRF token
config.filebrowserParams = function(){
var csrf_token = jQuery('meta[name=csrf-token]').attr('content'),
csrf_param = jQuery('meta[name=csrf-param]').attr('content'),
params = new Object();
if (csrf_param !== undefined && csrf_token !== undefined) {
params[csrf_param] = csrf_token;
}
return params;
};
config.addQueryString = function( url, params ){
var queryString = [];
if ( !params )
return url;
else
{
for ( var i in params )
queryString.push( i + "=" + encodeURIComponent( params[ i ] ) );
}
return url + ( ( url.indexOf( "?" ) != -1 ) ? "&" : "?" ) + queryString.join( "&" );
};
// Integrate Rails CSRF token into file upload dialogs (link, image, attachment and flash)
CKEDITOR.on( 'dialogDefinition', function( ev ){
// Take the dialog name and its definition from the event data.
var dialogName = ev.data.name;
var dialogDefinition = ev.data.definition;
var content, upload;
if ($.inArray(dialogName, ['link', 'image', 'attachment', 'flash']) > -1) {
content = (dialogDefinition.getContents('Upload') || dialogDefinition.getContents('upload'));
upload = (content == null ? null : content.get('upload'));
if (upload && upload.filebrowser['params'] == null) {
upload.filebrowser['params'] = config.filebrowserParams();
upload.action = config.addQueryString(upload.action, upload.filebrowser['params']);
}
}
});
/* Extra plugins */
// works only with en, ru, uk locales
config.extraPlugins = "embed,attachment";
/* Toolbars */
config.toolbar = 'Easy';
config.toolbar_Easy =
[
['Source','-','Preview'],
['Cut','Copy','Paste','PasteText','PasteFromWord',],
['Undo','Redo','-','SelectAll','RemoveFormat'],
['Styles','Format'], ['Subscript', 'Superscript', 'TextColor'], ['Maximize','-','About'], '/',
['Bold','Italic','Underline','Strike'], ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
['Link','Unlink','Anchor'], ['Image', 'Attachment', 'Flash', 'Embed'],
['Table','HorizontalRule','Smiley','SpecialChar','PageBreak']
];

config.toolbar_ContentToolbar =
    [
        { name: 'document',    items : [ 'Source','-',
          'Preview' ] },
        //{ name: 'document',    items : [ 'Source','-','Save','NewPage',
        //  'DocProps','Preview','Print','-','Templates' ] },    
        { name: 'tools',       items : [ 'Maximize' ] },
        //{ name: 'tools',       items : [ 'Maximize', 'ShowBlocks','-','About' ] }              
        { name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule',
          'Smiley','Blockquote','SpecialChar','PageBreak' ] },  
        { name: 'links', items : [ 'Link','Unlink' ] },
        //{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },  
        { name: 'editing',     items : [ 'Find','Replace','-','SelectAll','-',
          'SpellChecker' ] },       
        { name: 'undoredo',     items : [ 'Undo','Redo' ] },              
                '/',
        { name: 'styles',      items : [ 'Format' ] },
        //{ name: 'styles',      items : [ 'Styles','Format','Font','FontSize' ] },        
        { name: 'basicstyles', items : [ 'TextColor', 'Bold','Italic','Strike','RemoveFormat' ] },
        { name: 'paragraph',   items : [ 'NumberedList','BulletedList','-',
          'Outdent','Indent','-','JustifyLeft',
          'JustifyCenter','JustifyRight','JustifyBlock' ] },        
        //{ name: 'paragraph',   items : [ 'NumberedList','BulletedList','-',
        //  'Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft',
        //  'JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
        { name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText',
          'PasteFromWord'] }
        //{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule',
        //  'Smiley','SpecialChar','PageBreak','Iframe' ] },        
    ];
    
    config.toolbar_RefToolbar =
    [        
        { name: 'document',    items : [ 'Source'] },    
        { name: 'clipboard', items : [ 'Paste','PasteText'] },
        { name: 'links', items : [ 'Link','Unlink' ] },
        { name: 'editing',     items : [ 'SpellChecker' ] },       
        { name: 'undoredo',     items : [ 'Undo','Redo' ] }, 
        { name: 'paragraph',   items : [ 'NumberedList','BulletedList' ] }    
    ];
};

