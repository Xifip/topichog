/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.dialog.add("checkspell",function(a){function k(a,b){var c=0;return function(){typeof window.doSpell=="function"?(typeof f!="undefined"&&window.clearInterval(f),l(a)):c++==180&&window._cancelOnError(b)}}function l(b){var f=new window._SP_FCK_LangCompare,g=CKEDITOR.getUrl(a.plugins.wsc.path+"dialogs/"),h=g+"tmpFrameset.html";window.gFCKPluginName="wsc",f.setDefaulLangCode(a.config.defaultLanguage),window.doSpell({ctrl:d,lang:a.config.wsc_lang||f.getSPLangCode(a.langCode),intLang:a.config.wsc_uiLang||f.getSPLangCode(a.langCode),winType:c,onCancel:function(){b.hide()},onFinish:function(c){a.focus(),b.getParentEditor().setData(c.value),b.hide()},staticFrame:h,framesetPath:h,iframePath:g+"ciframe.html",schemaURI:g+"wsc.css",userDictionaryName:a.config.wsc_userDictionaryName,customDictionaryName:a.config.wsc_customDictionaryIds&&a.config.wsc_customDictionaryIds.split(","),domainName:a.config.wsc_domainName}),CKEDITOR.document.getById(e).setStyle("display","none"),CKEDITOR.document.getById(c).setStyle("display","block")}var b=CKEDITOR.tools.getNextNumber(),c="cke_frame_"+b,d="cke_data_"+b,e="cke_error_"+b,f,g=document.location.protocol||"http:",h=a.lang.spellCheck.notAvailable,i='<textarea style="display: none" id="'+d+'"'+' rows="10"'+' cols="40">'+" </textarea><div"+' id="'+e+'"'+' style="display:none;color:red;font-size:16px;font-weight:bold;padding-top:160px;text-align:center;z-index:11;">'+"</div><iframe"+' src=""'+' style="width:100%;background-color:#f1f1e3;"'+' frameborder="0"'+' name="'+c+'"'+' id="'+c+'"'+' allowtransparency="1">'+"</iframe>",j=a.config.wsc_customLoaderScript||g+"//loader.webspellchecker.net/sproxy_fck/sproxy.php"+"?plugin=fck2"+"&customerid="+a.config.wsc_customerId+"&cmd=script&doc=wsc&schema=22";return a.config.wsc_customLoaderScript&&(h+='<p style="color:#000;font-size:11px;font-weight: normal;text-align:center;padding-top:10px">'+a.lang.spellCheck.errorLoading.replace(/%s/g,a.config.wsc_customLoaderScript)+"</p>"),window._cancelOnError=function(b){if(typeof window.WSC_Error=="undefined"){CKEDITOR.document.getById(c).setStyle("display","none");var d=CKEDITOR.document.getById(e);d.setStyle("display","block"),d.setHtml(b||a.lang.spellCheck.notAvailable)}},{title:a.config.wsc_dialogTitle||a.lang.spellCheck.title,minWidth:485,minHeight:380,buttons:[CKEDITOR.dialog.cancelButton],onShow:function(){var b=this.getContentElement("general","content").getElement();b.setHtml(i),b.getChild(2).setStyle("height",this._.contentSize.height+"px"),typeof window.doSpell!="function"&&CKEDITOR.document.getHead().append(CKEDITOR.document.createElement("script",{attributes:{type:"text/javascript",src:j}}));var c=a.getData();CKEDITOR.document.getById(d).setValue(c),f=window.setInterval(k(this,h),250)},onHide:function(){window.ooo=undefined,window.int_framsetLoaded=undefined,window.framesetLoaded=undefined,window.is_window_opened=!1},contents:[{id:"general",label:a.config.wsc_dialogTitle||a.lang.spellCheck.title,padding:0,elements:[{type:"html",id:"content",html:""}]}]}}),CKEDITOR.dialog.on("resize",function(a){var b=a.data,c=b.dialog;if(c._.name=="checkspell"){var d=c.getContentElement("general","content").getElement(),e=d&&d.getChild(2);e&&e.setSize("height",b.height),e&&e.setSize("width",b.width)}});