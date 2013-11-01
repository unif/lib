window.P_vld = window.P_vld || {};
/**
* 检查有效数字
* @pThis	{Object}	
* @return	{Boolean}
*/
P_vld.chkNum = function(pThis) {
    if (isNaN(pThis.value)) {
        P_vld.doError(pThis, P_vld.f.errNumber);
    } else {
        P_vld.doError(pThis);
        return true;
    };
    return false;
};
/**
* 错误信息
*
*/
P_vld.f = {
    errClass: "apex-tabular-form-error",
    errNumber: "您录入了无效的数字，请重新录入！",
    errPct: "您录入了无效的数字，请重新录入！",
    errNgtNum: "您录入了负数或0，请重新录入！",
    errNull: "值不能为空，请录入。",
    errRepeat: "重复的值，请检查："

};
/**
* 错误信息处理函数
* @pThis	{Object}
* @pErrMsg	{String} 参数刚清除	errClass
*/
P_vld.doError = function(pThis, pErrMsg) {
    var c = P_vld.f.errClass;
    if (arguments.length == 1) {
        $(pThis).removeClass(c);
    } else {
        $(pThis).addClass(c);
        return alert(pErrMsg),
        pThis.value = "",
        !1
    }
};
/**
* 空值判断
* @pThis	{Object}
* @return	{Boolean} 
*/
P_vld.isNull = function(pThis) {
    if (pThis.value === "" || pThis.value === null) {
        P_vld.doError(pThis, P_vld.f.errNull);
    } else {
        P_vld.doError(pThis);
        return true;
    }
    return false;
};
/**
* 检查有效月份
* @pThis	{Object}
* @return	{Boolean} 
*/
P_vld.chkMon = function(pThis) {
    var p = pThis,
    r = new htmldb_Get(null, $v("pFlowId"), "APPLICATION_PROCESS=VALIDATE_MON", 0);
    r.addParam("x01", p.value);
    var g = r.get();
    if (g) {
        P_vld.doError(p, g);
    } else {
        P_vld.doError(p);
        return true;
    }
    return false;
};
/**
* 检查有效百分数
* @pThis	{Object}
* @return	{Boolean} 
*/
P_vld.chkPct = function(pThis, pMax) {
    var maxPct = pMax ? pMax: 100;
    function _chkNaN(index) {
        return isNaN(Number(c.substring(0, c.length - index)))
    }
    var p = pThis,
    c = p.value,
    d = false,
    e = c.substr(0, c.length - 1);
    c.substr(c.length - 1) == "%" ? (_chkNaN(1) ? P_vld.doError(p, P_vld.f.errPct) : (p.value = e, d = true)) : (_chkNaN(0) ? P_vld.doError(p, P_vld.f.errPct) : (
    /*p.value = p.value + "%", */
    d = true));
	d && c > maxPct && P_vld.doError(p,P_vld.f.errPct);
    d && P_vld.doError(p);
};
/**
* 检查非负数
* @pThis	{Object}
* @return	{Boolean} 
*/
P_vld.isNotNegative = function(pThis) {
    var p = pThis;
    if (P_vld.chkNum(p)) {
        if (parseFloat(p.value, 10) <= 0) {
            P_vld.doError(p, P_vld.f.errNgtNum);
            return false;
        } else {
            P_vld.doError(p);
            return true;
        }

    }
};
/**
* 检查重复值
* @pColumn	{String}
* @return	{Boolean} 
*/
P_vld.chkRepeat = function(pColumn) {
    var a = new Array(),
    b = new Array(),
    e = P_vld.f.errClass,
    items = $("input[name=" + pColumn + "]");
    items.each(function() {
        var p = $(this);
        p.val() && a.push(p.val());
        p.removeClass(e);
    });
    var s = a.join(",") + ",";
    for (var i = 0; i < a.length; i++) {
        if (s.replace(a[i] + ",", "").indexOf(a[i] + ",") > -1) {
            b.push(a[i]);
            //break;
        }
    }
    if (b.length > 0) {
        var str = b.join(",");
        items.each(function() {
            if (str.indexOf(this.value) > -1) {
                $(this).addClass(e);
            }
        });
        alert(P_vld.f.errRepeat + str);
        return false;
    } else {
        return true;
    }
}