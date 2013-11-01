/*
 *	Purpose  :	弹窗
 *	Author   :	
 *	Created  :	2011-12-21
 *	Upadated :	
 */
(function($) {
  $.htmldbDefaults = $.htmldbDefaults || {};
  $.htmldbDefaults.Dialog = {
    bgiframe: !0,
    autoOpen: !1,
    resizable: !0,
    modal: !0,
    show: 'slide',
    hide: 'slide',
    height: 'auto',
    minWidth: 200,
    target: null,
	content:null
  };

  $.htmldbDialog = {};
  $.htmldbDialog.Str = {
        titleMsg: '提示',
        ok: '确定',
        yes: '是',
        no: '否',
        cancel: '取消',
	    inputtext: '<input type="text" class="ui-dialog-inputtext"/>',
		textarea: '<textarea class="ui-dialog-textarea"></textarea>',
        waittingMsg: '正在处理,请稍候...'
  };
  $.htmldbDialog.open = function(p) {
    p = $.extend($.htmldbDefaults.Dialog, p);
    var dialogHtml = '<div id="htmldbDialog2011" style="display:none">' + '<table width="100%"><tr><td><div class=" ';
    if (p.type) {
      switch (p.type) {
      case 'question':
        dialogHtml += ' ui-icon-p ui-icon-question';
        break;
      case 'success':
        dialogHtml += ' ui-icon-p ui-icon-circle-check';
        break;
      case 'warn':
        dialogHtml += ' ui-icon-p ui-icon-warn';
        break;
      case 'error':
        dialogHtml += ' ui-icon-p ui-icon-error';
        break;
	  default: null;
      }
    };
    dialogHtml += '"></div></td><td width="80%"><div class="content">' + p.content + '</div></td></tr></table></div>';
    $(document.body).append(dialogHtml);

    $.Dialog = $("#htmldbDialog2011");
    $.Dialog.dialog({
      bgiframe: p.bgiframe,
      autoOpen: p.autoOpen,
      resizable: p.resizable,
      modal: p.modal,
      //show:p.show,
      hide: p.hide,
      title: p.title,
      height: p.height,
      minWidth: p.minWidth,
      close: function() {
        $(this).dialog('destroy');
        $.Dialog.remove();
      },
      buttons: p.buttons
    });
	
	if (p.target) { $("div.content").prepend(p.target);}
    $.Dialog.dialog('open');
  };
  $.htmldbDialog.close = function() {
    $.Dialog.dialog('close');
  };
  $.htmldbDialog.confirm = function(content, title, callback) {
    var p = {
      type: 'question',
      content: content,
      title: title,
      buttons: [
		{text: $.htmldbDialog.Str.cancel,
		 click:function(){$.htmldbDialog.close();}
        },
		{text:$.htmldbDialog.Str.ok,
		 click:function(){callback();$.htmldbDialog.close();}
		}
      ]
    };
    $.htmldbDialog.open(p);
  };

  $.htmldbDialog.prompt = function(title,value,multi, callback) {
        var target = $($.htmldbDialog.Str.inputtext);

        if(typeof(multi) == "function"){
            callback = multi;
        }
        if (typeof (value) == "function") {
            callback = value; 
        }
        else if (typeof (value) == "boolean") {
            multi = value;  
        }  
        if(typeof(multi) == "boolean" && multi)
        {	
			target = $($.htmldbDialog.Str.textarea);
        }
        if(typeof (value) == "string" || typeof (value) == "int")
        { 
            target.val(value);
        }
        p = {
            title: title,
			target: target,content:'',type:'',
            buttons: [{ text: $.htmldbDialog.Str.ok, click:function(){$.htmldbDialog.close();callback(target.val())}}, 
					  { text: $.htmldbDialog.Str.cancel, click:function(){$.htmldbDialog.close();}}]
        };
        $.htmldbDialog.open(p);
    };


  $.htmldbDialog.success = function(content, title, callback) {
    $.htmldbDialog.alert(content, title, 'success', callback);
  };
  $.htmldbDialog.error = function(content, title, callback) {
    $.htmldbDialog.alert(content, title, 'error', callback);
  };
  $.htmldbDialog.warn = function(content, title, callback) {
    $.htmldbDialog.alert(content, title, 'warn', callback);
  };
  $.htmldbDialog.alert = function(content, title, type, callback) {
    content = content || '';
	if (typeof(title) == "function") {
	  callback = title;
	  type = null;
	} else if (typeof(type) == "function") {
	  callback = type;
	}
	var btnclick = function(item, Dialog, index) {
	  $.htmldbDialog.close();
	  if (callback) callback(item, Dialog, index);
	};
    var p = {
      type: type,
      content: content,
	  target: '',
	  title:title,
	  buttons: [{ text: $.htmldbDialog.Str.ok, click: btnclick}]
    };
    $.htmldbDialog.open(p);
  };
})(jQuery);