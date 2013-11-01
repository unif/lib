function comboPage(pSelector, g) {
    var g = $.extend({
        url: null,
        ifrH: 300,
        ifrW: 500,
        ifc: 'comb_box',
        isOpen: false,
	    isAppend: false,
        dClass: null,
        removeEle: '#apex-dev-toolbar,#htmldbDevToolbar',
		arrClass:'.comb_arr',
		arrHover:'comb_arr_h',
        openClass:'isOpen',
		popup:"#uPopup",
		rir:"rir",
		dependingOnSelector: null,
        optimizeRefresh: true,
        pageItemsToSubmit: null,
		ajaxIdentifier:null,
		nullValue:null
    },
    g);

    var gP = $('#comb_dis_' + pSelector),
		did = g.ifc + "_" + pSelector,
		ifid = g.ifc + "_if_" + pSelector,
		gComb,gIfr;
	

    function _wrapContent() {
		var newP = $('#comb_dis_' + pSelector),
			loc = {left:newP.offset().left,
					top:parseInt(gP.offset().top + gP.outerHeight())};

		if (g.isAppend)
		{
			gComb.show().addClass(g.openClass).css(loc);
			return;
		}

		$(document.body).append("<div class='" + g.dClass + " " + g.ifc + "' id='" + did + "'><iframe id='" + ifid + 
								"' class='" + g.ifc + "_if" + "' frameborder='0' scrolling='no'></iframe></div>");

		gComb = $('#' + did);
		gComb.addClass(g.openClass).css(loc);
		gIfr = $('#' + ifid);

		g.isAppend = true;

        gIfr.attr({
            src: g.url,
            width: g.ifrW,
            height: g.ifrH
        }).bind('load',
        function() {
            gIfr.contents().find(g.removeEle).remove();
            //gIfr.contents().find('body').addClass(g.cbBodyClass);
        })

    };
    function _show() {
		var b = typeof(gComb)=="undefined"?true:(gComb.hasClass(g.openClass)?false:true);
        if (b) {
            _wrapContent();
            $(document).bind("click",
            function() {
                _hide();
            });
        }

    };
    function _hide() {
		var b = gComb.hasClass(g.openClass);
        if (b) {
            gComb.hide().removeClass(g.openClass);
            if (!b) {
                $(document).unbind("click", _hide());
            }
        }
    };
	
	function _comb_refresh() {
        gP.trigger("apexrefresh")
    }
    function _comb_afterRefresh(k) {
		typeof(gIfr)!="undefined"&&gIfr[0].contentWindow.searchIr();

        $(".apex-loading-indicator", gP).remove();
        gP.trigger("apexafterrefresh");
    }
    function _comb_beforeRefresh() {
        gP.trigger("apexbeforerefresh");
        if (g.optimizeRefresh) {
            var l = false;
            apex.jQuery(g.dependingOnSelector).each(function() { 
                if (apex.item(this).isEmpty()) {
                    l = true;
                    return false
                }
            });
            if (l) {
                gP.trigger("apexafterrefresh");
                return
            }
        }
        var j = {
            f01: [],
            f02: [],
            p_request: "PLUGIN=" + g.ajaxIdentifier,
            p_flow_id: $v("pFlowId"),
            p_flow_step_id: $v("pFlowStepId"),
            p_instance: $v("pInstance")
        };
        $(g.dependingOnSelector + "," + g.pageItemsToSubmit).each(function() {
            j.f01.push(this.id);
            j.f02.push($v(this))
        });

        gP.append('<span class="apex-loading-indicator"></span>'); 

        $.ajax({
            dataType: "json",
            type: "post",
            url: "wwv_flow.show",
            data: j,
            success: _comb_afterRefresh
        })
    }
	
	if (g.dependingOnSelector) {
        $(g.dependingOnSelector).change(_comb_refresh)	
    }
	gP.bind("apexrefresh", _comb_beforeRefresh);
    
    gP.unbind('click').bind('click',
    function(e) {
        _show();
        e.stopPropagation();
    });

	$(gP).hover(function(){
		$(g.arrClass,$(this)).addClass(g.arrHover)
	},function(){
		$(g.arrClass,$(this)).removeClass(g.arrHover)
	});

}