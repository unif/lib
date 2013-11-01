window.P_vld = window.P_vld || {};
/**
* �����Ч����
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
* ������Ϣ
*
*/
P_vld.f = {
    errClass: "apex-tabular-form-error",
    errNumber: "��¼������Ч�����֣�������¼�룡",
    errPct: "��¼������Ч�����֣�������¼�룡",
    errNgtNum: "��¼���˸�����0��������¼�룡",
    errNull: "ֵ����Ϊ�գ���¼�롣",
    errRepeat: "�ظ���ֵ�����飺"

};
/**
* ������Ϣ������
* @pThis	{Object}
* @pErrMsg	{String} ���������	errClass
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
* ��ֵ�ж�
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
* �����Ч�·�
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
* �����Ч�ٷ���
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
* ���Ǹ���
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
* ����ظ�ֵ
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