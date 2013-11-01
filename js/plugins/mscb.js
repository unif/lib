$(document).ready(function() {
    $.expr[":"].containsIgnoreCase = function(c, b, a) {
        return jQuery(c).text().toLowerCase().indexOf(a[3].toLowerCase()) >= 0
    }
});

var mscbList = function(c, e) {
    var g = apex.jQuery.extend({
        dependingOnSelector: null,
        optimizeRefresh: true,
        pageItemsToSubmit: null,
        optionAttributes: null,
        nullValue: "",
		isOpen:false,
		isInit:false,
		enableSearch:'N',
		labels:"",
		arrClass:'.comb_arr',
		arrHover:'comb_arr_h',
		customLabel:'N',
		optionHeight:screen.height*2/5
    },
    e),
	  itemId = c.substring(1, c.length)
	, gValue = $("#" + itemId).val()
	, gIpt = $("#comb_tool_ipt_"+itemId)
	, gOption = $("#comb_option_" + itemId)
	, gCbAll = $("#comb_tbar_cb_" + itemId)
	, gBox = $("#comb_box_" + itemId)
	, gLabel = $("#comb_dis_ipt_"+ itemId)
	, gDis = $("#comb_dis_"+ itemId)
	, gOpen = gDis.next('.open'); 

	function _hide(){
		if (g.isOpen)
		{	gBox.hide();//slideToggle();
			g.isOpen = false;
		}	
	};
	function _show(){
		if (!g.isOpen)
		{	g.customLabel == 'Y' && gBox.css('left',gDis.offset().left - 1);
			gBox.show();
			g.isOpen = true;			
		}
	};
	function _comb_handleCheckAll() {
		var c = gCbAll[0].checked;//全选
		var f = gOption.scrollTop();
		$("input[type=checkbox]",gOption).attr("checked",c);
		gOption.scrollTop(f);
	};

    function _comb_refresh() {
        gBox.trigger("apexrefresh")
    }
    function _comb_afterRefresh(k) {
        $(".apex-loading-indicator", gDis).remove();
        if (k.error) {
            alert(k.error);
            return false
        }
        var j = "",
        	m = gCbAll[0].checked,//全选
        	l = gValue.split(":");//项值 

        apex.jQuery.each(k, //k为response的json对象
        function() {
			var wrap = '<li class="option"><input type="checkbox" value="'
			, wrap2 = '" checked="checked"><label>', wrap3 = "</label></li>";

            if (m) {
                j = j + wrap + this.r + wrap2 + this.d + wrap3
            } else {
                var p = false;
                for (i = 0; i < l.length && !p; i++) {
                    if (this.r == l[i]) {
                        p = true
                    }
                }
                if (p) {//已选的
                    j = j + wrap + this.r + wrap2 + this.d + wrap3
                } else {
                    j = j + wrap + this.r + '"><label>' + this.d + wrap3
                }
            }
        });
		gOption.append('<ul class="options">'+j+'</ul>');
		_checkOption();
        gBox.trigger("apexafterrefresh");
    }
    function _comb_beforeRefresh() {
    	//清空标签值
    	gLabel.val("");
        gBox.trigger("apexbeforerefresh");
        $("ul.options",gOption).remove(); //清空值
        gBox.change();
        if (g.optimizeRefresh) {
            var l = false;
            apex.jQuery(g.dependingOnSelector).each(function() { //dependingOnSelector 级联项
                if (apex.item(this).isEmpty()) {
                    l = true;
                    return false
                }
            });
            if (l) {
                gBox.trigger("apexafterrefresh");
                return
            }
        }
        var j = {
            p_arg_names: [],
            p_arg_values: [],
            p_request: "NATIVE=" + g.ajaxIdentifier,
            p_flow_id: $v("pFlowId"),
            p_flow_step_id: $v("pFlowStepId"),
            p_instance: $v("pInstance")
        };
        apex.jQuery(g.dependingOnSelector).add(g.pageItemsToSubmit).each(function() {
            var m = j.p_arg_names.length;
            j.p_arg_names[m] = this.id;
            j.p_arg_values[m] = $v(this)
        }); 

        gDis.append('<span class="apex-loading-indicator"></span>'); 
        //清空搜索框
        gIpt.val("");

        apex.jQuery.ajax({
            mode: "abort",
            port: "comb_option" + c,
            dataType: "json",
            type: "post",
            url: "wwv_flow.show",
            traditional: true,
            data: j,
            success: _comb_afterRefresh
        })
    };
    
    //勾选
	function _checkOption(){
		$("li.option",gOption).click(function(e){
			if (e.target.nodeName!='INPUT') {
				var a = $(this).find('input'),
					b = a[0].checked;
				a.attr('checked',!b);
			}
		});
	};

    //点击下拉框，刷新显示项值
	function _comb_boxClick(o) {
		var p = $("li.option input:checked",o),
			b = $("#" + itemId);
		var c = p.map(function() {
			return $(this).val()
		}).get().join(":");
		var d = p.map(function() {
			return $(this).next().text()
		}).get().join(",");
		
		b.val(c);
		gLabel.val(d);

	}

    //搜索
	function _handleSearch(d) {
		var a = gIpt.val();
		var f = $("li.option",gOption);
		var n = gCbAll.parent();

		f.hide();

		if (a != null && a.length > 0) {
			var p = $("label:containsIgnoreCase('" + a.toLowerCase() + "')",f);

			p.length>1?n.show():n.hide();
			p.parent().show()
		} else {
			f.show();
			n.show();
		}
	};

	//外部点击，隐藏下拉框
	function _doMouseDown(e){
		var c = e.target,
        d = $(c).closest(gBox),
		e = $(c).closest(gOpen),
		f = $(c).closest(gDis);
        if (!(d.length || e.length || f.length)) {
          _hide();
        }
	};
	//初始化
	function _init(){
	
		if (!g.isInit) {
			$(document).mousedown(_doMouseDown);
		};
		gBox.width(gDis.outerWidth() + gOpen.outerWidth());
		gOption.css("max-height",g.optionHeight);

		gBox.each(function() {
			apex.widget.initPageItem(this.id, {
				nullValue: g.nullValue
			})
		});
		
		if (g.dependingOnSelector) {//绑定级联刷新事件
			apex.jQuery(g.dependingOnSelector).change(_comb_refresh)
		}

		gBox.bind("apexrefresh", _comb_beforeRefresh); 

		//打开下拉框
		gOpen.click(function(e){
			_show();
			e.stopPropagation();
		});
		gDis.click(function(e){
			_show();
			e.stopPropagation();
		});
		//延迟绑定事件
		setTimeout(function(){
			gBox.click(function(e){
				_comb_boxClick(gBox);
				e.stopPropagation();
			});
			//
			_checkOption();
			//搜索
			gIpt.keyup(function(){
				_handleSearch();
			});
			//全选
			gCbAll.change(function(){
				_comb_handleCheckAll()
			});
		},600);
	};

	//´´½¨
	_init();
};
