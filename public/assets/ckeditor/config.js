/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.editorConfig=function(a){a.filebrowserBrowseUrl="/ckeditor/attachment_files",a.filebrowserFlashBrowseUrl="/ckeditor/attachment_files",a.filebrowserFlashUploadUrl="/ckeditor/attachment_files",a.filebrowserImageBrowseLinkUrl="/ckeditor/pictures",a.filebrowserImageBrowseUrl="/ckeditor/pictures",a.filebrowserImageUploadUrl="/ckeditor/pictures",a.filebrowserUploadUrl="/ckeditor/attachment_files",a.filebrowserParams=function(){var a=jQuery("meta[name=csrf-token]").attr("content"),b=jQuery("meta[name=csrf-param]").attr("content"),c=new Object;return b!==undefined&&a!==undefined&&(c[b]=a),c},a.addQueryString=function(a,b){var c=[];if(!b)return a;for(var d in b)c.push(d+"="+encodeURIComponent(b[d]));return a+(a.indexOf("?")!=-1?"&":"?")+c.join("&")},CKEDITOR.on("dialogDefinition",function(b){var c=b.data.name,d=b.data.definition,e,f;if($.inArray(c,["link","image","attachment","flash"])>-1){e=d.getContents("Upload")||d.getContents("upload"),f=e==null?null:e.get("upload");if(f&&f.filebrowser["params"]==null){f.filebrowser.params=a.filebrowserParams(),f.action=a.addQueryString(f.action,f.filebrowser.params);if(c=="link"){d.removeContents("advanced");var g=d.getContents("target"),h=g.get("linkTargetType");h["default"]="_blank"}}}}),a.extraPlugins="embed,attachment",a.toolbar="Easy",a.toolbar_Easy=[["Source","-","Preview"],["Cut","Copy","Paste","PasteText","PasteFromWord"],["Undo","Redo","-","SelectAll","RemoveFormat"],["Styles","Format"],["Subscript","Superscript","TextColor"],["Maximize","-","About"],"/",["Bold","Italic","Underline","Strike"],["NumberedList","BulletedList","-","Outdent","Indent","Blockquote"],["JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock"],["Link","Unlink","Anchor"],["Image","Attachment","Flash","Embed"],["Table","HorizontalRule","Smiley","SpecialChar","PageBreak"]],a.toolbar_ContentToolbar=[{name:"document",items:["Source"]},{name:"tools",items:["Maximize"]},{name:"insert",items:["Image","Flash","Table","HorizontalRule","Smiley","Blockquote","SpecialChar","PageBreak"]},{name:"links",items:["Link","Unlink"]},{name:"editing",items:["Find","Replace","-","SelectAll","-","Scayt"]},{name:"clipboard",items:["Cut","Copy","Paste"]},"/",{name:"styles",items:["Format","FontSize"]},{name:"basicstyles",items:["TextColor","Bold","Italic","Strike","RemoveFormat"]},{name:"paragraph",items:["NumberedList","BulletedList","-","Outdent","Indent","-","JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock"]},{name:"undoredo",items:["Undo","Redo"]}],a.toolbar_RefToolbar=[{name:"document",items:["Source"]},{name:"clipboard",items:["Paste","PasteText"]},{name:"links",items:["Link","Unlink"]},{name:"editing",items:["SpellChecker"]},{name:"undoredo",items:["Undo","Redo"]},{name:"paragraph",items:["NumberedList","BulletedList"]},{name:"styles",items:["FontSize"]}]};