(function() {
  $.tabDefaults = $.tabDefaults || {};
  $.tabDefaults = {
    tabCounter: 2,
    tabTl: "<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close'>删除标签</span></li>",
    tabClose: "span.ui-icon-close"
  };
  $.fn.usTabs = function(p) {
    p = $.extend({},
    $.tabDefaults, p || {});
    var $tabs = this.tabs({
      tabTemplate: p.tabTl,
      add: function(event, ui) {
        $(ui.panel).show();
        $(ui.tab).parent().find(p.tabClose).click(function() {
          $tabs.tabs('remove', $('li', $tabs).index($(this).parents('li:first')[0]));
        });
        $tabs.tabs('select', '#' + ui.panel.id);
      }
    });

    function addTab() {
      $tabs.tabs("add", "#tabs-" + p.tabCounter, "Tab " + p.tabCounter);
      p.tabCounter++;
    }
    var tabInstance = {
      addTab: addTab
    };
    return tabInstance;
  };

})(jQuery);
/*
 *	Purpose  :	垂直滚动,并冻结列标题
 *	Author   :	
 *	Created  :	2011-12-17
 *	Upadated :	2011-12-18
 */
(function($) {
  $.fn.htmldbScroll = function(opt) {
    var defaults = {
      divHeight: '200px',
	  sbarClass:''
    };
    opt = $.extend(defaults, opt);
    this.each(function() {
      var p = $(this);
      var a = $("div.vs_bottom", p),
      b = $("div.vs_bottom table:first", p),
      btr = $('tr:first', b),
      bh = b.height(),
      c = $("div.vs_top table thead", p);

	  if (bh <= parseInt(opt.divHeight.replace('px', '')))
	  {
		  return false;
	  }
      btr.children().each(function(i) {
        var x = $(this),
        xl = x.css("padding-left"),
        xr = x.css("padding-right"),
        w = x.outerWidth() - parseInt(xl.replace("px", "")) - parseInt(xr.replace("px", ""));/*outerWidth包括了左右填充部分*/
        x.width(w);
      });
      c.append(btr);
      a.width(parseInt(b.width()) + 20);
      // add th element
	  $("tr:first",c).append($("<th/>", {
          "class": opt.sbarClass
        }));
	  // set scroll div height
      a.css({
        "height": opt.divHeight
      }).scrollTop(0);
    });
  };
})(jQuery);
/*
 *	Purpose  :	单据多张与单据审核
 *	Author   :	
 *	Created  :	2011-12-19
 *	Upadated :	2011-12-19
 *  Example  :  $("#apexir_DATA_PANEL  TD[headers='SELECT'] INPUT:checked").checkBill({checkType: 'CHECK'});}
 */
(function($){
	$.fn.checkBill = function(opt){
		opt = $.extend({
			checkType:null,
			checkMsg:'请选择要审核的单据',
		    uncheckMsg:'请选择要反审核的单据',
			checkSuccess:'审核成功',
			uncheckSuccess:'反审核成功'
		},opt);
		var a = opt.checkType == "CHECK" ? opt.checkMsg: opt.uncheckMsg,
		b = opt.checkType == "CHECK" ? opt.checkSuccess: opt.uncheckSuccess;
		var r = new htmldb_Get(null, $v("pFlowId"), "APPLICATION_PROCESS=CheckBill", $v("pFlowStepId"));
		r.addParam("x01", opt.checkType);
		if (!this.length){
			$.htmldbDialog.warn(a,'提示信息',null);
			return false
		}
		this.each(function(i){
			var $c = $(this),
			d = $c.attr("check:status"),
			e = $c.attr("check:billno");
			opt.checkType == "CHECK" ? (d == "0" ? r.addParam("f01", e) : null) : (d == "1" ? r.addParam("f01", e) : null)
		});
		var g = r.get();
		g == "SUCCESS" ? ($.htmldbDialog.success(b,'提示信息',null), gReport.search("SEARCH")) : $.htmldbDialog.error(g,'提示信息',null);
                  return
	}
})(jQuery);
/*
 *	Purpose  :	模式窗口弹出iframe，显示其它页面
 *	Author   :	
 *	Created  :	
 *	Upadated :	
 */
(function() {
  $.widget('ui.iframe_page', {
    options: {
      url: null,
      dialogTitle: null,
      iframeHeight: 400,
      iframeWidth: 800,
	  hide:'slide',
	  show:'slide'
    },
    _createPrivateStorage: function() {
      var self = this;
      self._elements = {
        $dialog: {},
        $iframe: {}
      };
    },
    _initElements: function() {
      var self = this;
      self._elements.$dialog = $('div.ifPage');
      self._elements.$iframe = $('iframe#iframe_page');
    },
    _create: function() {
      var self = this;
      self._createPrivateStorage();
    },
    _init: function() {
      var self = this;
      self.createPage();
      self.openPage();
    },

    createPage: function() {
      var self = this;

      var dialogHtml = '<div class="ifPage">\n' + '<iframe id="iframe_page" name="iframe_page" frameborder="0" scrolling="auto"></iframe>' + '</div>\n';

      $(document.body).append(dialogHtml);

      self._initElements();
      self._elements.$iframe.attr({
        src: self.options.url,
        width: self.options.iframeWidth,
        height: self.options.iframeHeight
      }).bind('load', {
        self: self
      },
      self._handleIframeLoad);
      self._elements.$dialog.dialog({
        autoOpen: false,
        height: "auto",
        modal: true,
        resizable: true,
        title: self.options.dialogTitle,
        width: "auto",
		hide:self.options.hide,
        close: function() {
          $(this).dialog('destroy');
          self._elements.$dialog.remove();
		  if (typeof(gReport) != "undefined")
		  {
			   gReport.search('SEARCH');
		  }
		}
      });
    },
    _handleIframeLoad: function(eventObj) {
      var self = eventObj.data.self;
      self._elements.$iframe.contents().find('#apex-dev-toolbar,#htmldbDevToolbar').remove();
    },
    openPage: function() {
      var self = this;
      self._elements.$dialog.dialog('open');
    }
  });
})(jQuery);

function openPage(p) {
    var g = $.extend({
        url: null,
        dialogTitle: null,
        iframeHeight: 400,
        iframeWidth: 800,
        hide: 'slide',
        show: 'slide',
		closeR: 'Y',
		isDialog: 'N'
    },
    p);
	if (g.isDialog == 'N'){
		redirect(g.url);
		return;
	} 

    var dialogHtml = '<div class="ifPage">' + '<iframe id="iframe_page" frameborder="0" scrolling="no"></iframe>' + '</div>';
    $(document.body).append(dialogHtml);
    gD = $('div.ifPage');
    gF = $('#iframe_page');
    gF.attr({
        src: g.url,
        width: g.iframeWidth,
        height: g.iframeHeight
    }).bind('load',function(){
		gF.contents().find('#apex-dev-toolbar,#htmldbDevToolbar').remove();
	});

    gD.dialog({
        autoOpen: false,
        height: "auto",
        modal: true,
        resizable: true,
        title: g.dialogTitle,
        width: "auto",
        hide: g.hide,
        close: function() {
            $(this).dialog('destroy');
            gD.remove();
            if (typeof(gReport) != "undefined") {
                gReport.search('SEARCH');
            }else {
				if (g.closeR=='Y'){
					redirect("f?p="+$v("pFlowId")+":"+$v("pFlowStepId")+":"+$v("pInstance"));
				}
			}
        }
    });

    gD.dialog('open');
}
/*
 *	Purpose  :	输入栏位onchange时通过编号取名称
 *	Author   :	
 *	Created  :	2013-1-5
 *	Upadated :	
 *  Exanple  : onchange="getLov(this,'SU','2:4')"
 */
function getLov(p, pType, pIndex) {
    switch (pType) {
    case 'F':
        getData('branch_no:branch_name', 'pub112t0', p, pIndex);
        break;
    case 'R':
        getData('regi_id:regi_nm', 'v_region_code', p, pIndex);
        break;
    case 'E':
        getData('entitycode:entityname', 'blm_entity', p, pIndex);
        break;
    case 'S':
        getData('sku_no:sku_nm', 'sku', p, pIndex);
        break;
    case 'P':
        getData('goods_id:goods_nm', 'blm008t0', p, pIndex);
        break;
	case 'SU':
        getData('sub_code:ch_name', 'sub_code', p, pIndex);
        break;
    default:
        null;
    }
}
/*
 *	Purpose  :	tabular表单工具函数
 *	Author   :	
 *	Created  :	2013-01-04
 *	Upadated :	
 */
function tabularEmpty(){
   return pad((apex.widget.tabular.gNumRows + apex.widget.tabular.gNewRows),4)=="0000";
}
function tabularInitRow(n, col, year) {
  var vs = [];
  $("input[name=" + col + "]").each(function(index) {
	var v = $(this).val();
	v&&vs.push(v);
  })

  for (var i=1;i<=n;i++){
	  var mon = year + pad(i, 2);
	  if ($.inArray(mon,vs) == -1){
		addRow();
		var no = pad((apex.widget.tabular.gNumRows + apex.widget.tabular.gNewRows),4);
		$("#"+col+"_"+no).val(mon);
	  }
  }
}
function tabularCopyRow(n, cols) {
    var a = cols.split(',');
    for (var i = 0; i < a.length; i++) {
        var id1 = a[i] + "_0001",
        v1 = $v(id1);
        if (v1) {
            for (var j = 2; j <= n; j++) {
                var id = a[i] + "_" + pad(j, 4), v = $v(id);;
				v?v!=v1&&$("#"+id).val(v1).trigger("change"):$("#"+id).val(v1).trigger("change");
            }
        }
    }
}
/*
 *	Purpose  :	设置会话状态
 *	Author   :	
 *	Created  :	2011-12-21
 *	Upadated :	
 */
(function(a) {
  a.htmldbAjax = function(b) {
    b = a.extend(true, {
      url: "wwv_flow.show",
      dataType: "html",
      traditional: true,
      cache: false,
      type: "POST",
      data: {
        p_flow_id: $v("pFlowId"),
        p_flow_step_id: $v("pFlowStepId"),
        p_instance: $v("pInstance"),
        p_request: "APPLICATION_PROCESS=DUMMY"
      }
    },
    b);
    a.ajax(b)
  };
	a.fn.htmldbSetSession = function(b) {
    var d = [],
    c = [];
    this.each(function() {
      this.id && (d.push(this.id), $v(this) ? c.push($v(this)) : c.push(""))
    });
    b = a.extend(true, {
      dataType: "text",
      data: {
        p_arg_names: d,
        p_arg_values: c
      }
    },
    b);
    a.htmldbAjax(b);
    return this
  };
  a.htmldbSetSession = function(b, d) { 
    var c = [],
    e = [];
    a.each(b,
    function(a, b) {
      c.push(a);
      e.push(b)
    });
    d = a.extend(true, {
      dataType: "text",
      data: {
        p_arg_names: c,
        p_arg_values: e
      }
    },
    d);
    a.htmldbAjax(d)
  };
})(jQuery);
/*
 *	Purpose  :	区域避罩
 *	Author   :	
 *	Created  :	2012-6-27
 *	Upadated :	
 *  Example  :  $.gRefresh.region({selector:'#rep-order', repRegion: '.us-panel-body',items: '#P2021_BEGDATE,#P2021_ENDDATE,#P2021_ROWS,#P2021_SEARCH'
   });
 */
(function($) {
  $.gRefresh = $.gRefresh || {};
  $.gRefresh.Defaults = {
    load: 'l-load-c',
    mask: 'ui-widget-overlay',
    items: null,
    selector: null,
    repRegion: null,
	paraType: 0,
	hwAjust: 30
  };
  $.gRefresh.region = function(opt) {
    opt = $.extend($.gRefresh.Defaults, opt);
    gr = $(opt.selector);
    $.gRefresh.mask(gr, opt);
	if (opt.paraType==0)
	{
		$(opt.items).htmldbSetSession({
		  success: function(data) {
			if (!data) {
			  $.gRefresh.removemask(gr, opt);
			}else {
			  alert(data);
			}
		  }
		});
	}else{
		$.htmldbSetSession(opt.items,{success:function(data){//eval('('+opt.items+')'
			if (!data) {
			  $.gRefresh.removemask(gr, opt);
			}else {
			  alert(data);
			}
		}});
	}
  };
  $.gRefresh.mask = function(r, p) {
    l = r.offset().left,
    t = r.offset().top,
    h = r.height(),
    w = r.width();
    r.after("<div class='" + p.mask + "' style='position:fixed;top:" + t + "px;left:" + l + "px;width:" + w + "px;height:" + h + "px'></div>");
    r.after("<div class='" + p.load + "' style='position:fixed;top:" + (t + p.hwAjust / 2) + "px;left:" + (l + w / 2 - p.hwAjust) + "px'></div>");
  };
  $.gRefresh.removemask = function(r, p) {
    r.find(p.repRegion).trigger('apexrefresh').unbind('apexafterrefresh').bind('apexafterrefresh',
    function() {
      $('.' + p.mask + ', .' + p.load).remove();
    });
  }
})(jQuery);

function arrowKey(pSelector) {
  $(pSelector).keydown(function() {
    var evt = (evt) ? evt: ((window.event) ? window.event: "");
    var key = evt.keyCode ? evt.keyCode: evt.which;

    //window.event.keyCode = (window.event.keyCode == 13) ? 9 : window.event.keyCode;

    if (key == 37 || key == 38 || key == 39 || key == 40) {
      var Thistd = document.activeElement.parentNode;
      var Parenttr = $x_UpTill(Thistd, 'TR');
      var Parenttab = $x_UpTill(Parenttr, 'TABLE');
      var rows = Parenttab.rows;
      var cells = Parenttr.cells;
      var j = Thistd.cellIndex;
      var i = Parenttr.rowIndex;
      var inputs = "";

      switch (key) {
      case 37:
        if (j - 1 < 0) return false;
        if (rows[i].cells[j - 1].childNodes.length != 0) {
          inputs = rows[i].cells[j - 1].childNodes;
        }
        break;
      case 38:
        if (i - 1 < 0) return false;
        if (rows[i - 1].cells[j].childNodes.length != 0) {
          inputs = rows[i - 1].cells[j].childNodes;
        }
        break;
      case 39:
        if (j + 1 >= cells.length) return false;
        if (rows[i].cells[j + 1].childNodes.length != 0) {
          inputs = rows[i].cells[j + 1].childNodes;
        }
        break;
      case 40:
        if (i + 1 >= rows.length) return false;
        if (rows[i + 1].cells[j].childNodes.length != 0) {
          inputs = rows[i + 1].cells[j].childNodes;
        }
        break;
      }
      if (inputs != "") {
        for (var k = 0; k < inputs.length; k++) {
          if (inputs[k].type == "text") {
            inputs[k].focus();
          }
        }
      }
    }
  })
}
/*
 *	Purpose  :	按回车或点击查询刷新报表
 *	Author   :	
 *	Created  :	2012-03-09
 *	Upadated :	
 */
function refreshRep(p, repId, reset) {
  var aR = new htmldb_Get(null, $v('pFlowId'), 'APPLICATION_PROCESS=dummy', 0);
  if (reset=='N')
  {
	  aR.add(p.id, p.value);
  }else{
	  aR.add(p.id, '');
	  $x_Value(p.id,'');
  }
  var gR = aR.get();
  if (!gR) {
    $('#' + repId + ' div.borderless-region').trigger('apexrefresh');
  }
}
function searchRep(p, repId) {
  $($x_UpTill(p, 'TR')).find('input:text').each(function() {
    refreshRep(this, repId, 'N');
  })
}
/*
 *	Purpose  :	刷新IR
 *	Author   :	
 *	Created  :	2012-05-14
 *	Upadated :	
 */
function refreshIR(a, b) {
  var ul=$('ul.tabbed-navigation-list'),li=$('li',ul);
  li.removeClass('active');
  var items=eval(a);
  $.htmldbSetSession(items,{success:function(){gReport.search("SEARCH");}});
  li.filter(function(index){return $(this).text()==b;}).addClass('active');
}

function fnIrRefresh(pThis) {
	var g = new htmldb_Get(null,$v('pFlowId'),'APPLICATION_PROCESS=DUMMY',0);
	g.add(pThis.id,$v(pThis.id));
	var r = g.get();
	gReport.search('SEARCH');
	r = null;
}
/*
 *	Purpose  :	明细表格添加多行
 *	Author   :	
 *	Created  :	2012-05-25
 *	Upadated :	
 */
function addRows(n){
  for (var i=0;i<n ;i++ ){
	addRow();
  }
}

/*
 *	Purpose  :	最后录入项按回车添加行
 *	Author   :	
 *	Created  :	2012-05-25
 *	Upadated :	
 */
function enterAddRow(e,p,c,f){
	if($f_Enter(e)) {
		var tr = $x_UpTill(p,'TR'),tab = $x_UpTill(p,'TABLE');
		$(tab).find("td[headers='CHECK$01']").text().match(/合计/)?s=1:s=0;
		tr.rowIndex == parseInt(gNumRows+gNewRows+s)?addRow():null;
		setTimeout(function(){
			$('#'+'f'+pad(c,2)+'_'+pad((gNumRows+gNewRows),4)).focus();
			typeof f=="function"&&f();
		},200);
	}
}
function Get_Info_From_Server(pSelect, pFrom, pThis, pReturnPosOrID) {
  var l_Return_Column_Index = pReturnPosOrID.split(':');
  var l_Tr = pThis.parentNode.parentNode;
  var l_Request = new apex.ajax.ondemand('GET_DATA_FROM_DB',
  function() {
    var l_s = p.readyState;
    if (l_s == 1 || l_s == 2 || l_s == 3) {} else if (l_s == 4) {
      var l_Result = p.responseText.split(':');
      for (var j = 0; j < l_Result.length; j++) {
        if (isNaN(l_Return_Column_Index[0])) {
          if ($x(l_Return_Column_Index[j]).nodeName == 'INPUT') {
            $x(l_Return_Column_Index[j]).value = l_Result[j];
          } else {
            $x(l_Return_Column_Index[j]).innerHTML = l_Result[j];
          }
        } else {
          if (typeof(l_Tr.cells[l_Return_Column_Index[j]].getElementsByTagName('INPUT')[0]) != "undefined") {
            l_Tr.cells[l_Return_Column_Index[j]].getElementsByTagName('INPUT')[0].value = l_Result[j];
          } else {
            l_Tr.cells[l_Return_Column_Index[j]].innerHTML = l_Result[j];
          }
        }
      }
    } else {
      return false;
    }
  });
  l_Request.ajax.addParam('x01', pSelect);
  l_Request.ajax.addParam('x02', pFrom);
  l_Request.ajax.addParam('x03', pThis.value);
  l_Request.ajax.addParam('x04', l_Return_Column_Index.length);
  l_Request._get();
}
/*
 *	Purpose  :	按钮下载经典报表
 *	Author   :	
 *	Created  :	2013-07-15
 *	Upadated :	
 */
function downloadReport(ele){
	var sID = $('#'+ele).find('div[id^=report_]').attr('id'),
		sReportID = sID.match(/\d+/g);
	apex.submit('GO');
	apex.navigation.redirect('f?p='+$v('pFlowId')+':'+$v('pFlowStepId')+':'+$v('pInstance')+':FLOW_EXCEL_OUTPUT_R'+sReportID+'_zh-cn');
}
/*
 *	Purpose  :	函数适配
 *	Author   :	
 *	Created  :	2011-12-21
 *	Upadated :	
 */
var getData = Get_Info_From_Server;
var addDetailRow = addRow;

/*
 *	Purpose  :	返回顶部
 *	Author   :	
 *	Created  :	2013-01-02
 *	Upadated :	
 */
function backToTop(){
	document.documentElement.scrollTop+document.body.scrollTop>300?document.getElementById("toTop").style.display="block":document.getElementById("toTop").style.display="none"
}
$(function(){
	window.onscroll = backToTop
})