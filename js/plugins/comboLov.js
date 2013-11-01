function comboLov(pSelector, g) {
	var g = $.extend({
		isOpen: false,
		isInit: false,
		dependingOnSelector: null,
		optimizeRefresh: true,
		pageItemsToSubmit: null,
		ajaxIdentifier: null,
		nullValue: null,
		nullText: null,
		retColIdx: 1,
		disColIdx: 2,
		currentPage: 1,
		maxRowsPerPage: 15,
		displayMode: 'NAME'
	},g);

	var oData = {
		p_request: "NATIVE=" + g.ajaxIdentifier,
		p_flow_id: $v("pFlowId"),
		p_flow_step_id: $v("pFlowStepId"),
		p_instance: $v("pInstance")
	};

	var oFieldSet = $('#' + pSelector + '_fieldset'),
		oWrap = $('#' + pSelector + '_wrap'),
		oWrapCont = $('.cont', oWrap),
		oNext = $('a.next', oWrap),
		oPrev = $('a.prev', oWrap),
		oSearch = $('#' + pSelector + '_search'),
		oOpen = $('td.open', oFieldSet),
		oHiddenInput = $('#' + pSelector + '_HIDDENVALUE'),
		oDisInput = $('#' + pSelector)
		oDisLabel = $('#' + pSelector + '_name'),
		oLov = $('td.lov', oFieldSet),
		nDisHeight = oLov.outerHeight(),
		nDisWidth = oLov.outerWidth(),
		nIndex = 0,
		sPrevSearchValue = '',
		bValidVal = false,
		vExtraVal = [],/* 其他项值数组*/
		oRows = {},
		oKeys = {
			up: 38,
			down: 40,
			enter: 13,
			tab: 9,
			esc: 27
		};
	function _fetchData(newPgn) {
		if (!newPgn) {
			//处理上一页、下一页
			var b = (g.currentPage - 1) * g.maxRowsPerPage + 1,
				e = g.currentPage * g.maxRowsPerPage;
			g.newRows = b + ':' + e;
		} else {
			//重新分页
			g.newRows = '1:' + g.maxRowsPerPage;
			oPrev.hide();
		}
		var j = $.extend({
			p_arg_names: [],
			p_arg_values: [],
			x02: g.newRows,
			x04: oSearch.val()
		},
			oData);
		//级联项和提交项
		$(g.dependingOnSelector).add(g.pageItemsToSubmit).each(function(index) {
			j.p_arg_names[index] = this.id;
			j.p_arg_values[index] = $v(this)
		});

		$.ajax({
			type: 'post',
			url: 'wwv_flow.show',
			data: j,
			success: function(data) {
				oWrapCont.html(data);
				//绑定报表行点击事件
				_handdleRowClick();
				//重置分页
				_resetPagination();
				//绑定键盘方向键事件
				_doKeydown();
				g.isInit = true;
			}
		});
	};
	function _initReport(){
		var b = false,
		oReport = $('#' + pSelector + '_report');
		oRows = $('tbody tr', oReport);

		//hightline 已选
		oRows.each(function(index) {
			var r = $(this),
				ret = r.find('td:eq(' + parseInt(g.retColIdx - 1) + ')').text();
			if (ret == oDisInput.val()) {
				_hilightRow(r);
				b = true;
				nIndex = index;
			};
		});
		//当前页没有选中的行
		b || (nIndex = -1);
	};
	function _handdleRowClick() {
		_initReport();
		oRows.die('click').live('click', function(e) {
			vExtraVal = [];
			var p = $(this),
				retValue = p.attr("data-ret"),
				//p.find('td:eq(' + parseInt(g.retColIdx - 1) + ')').text(),
				disValue = p.attr("data-dis");
				//p.find('td:eq(' + parseInt(g.disColIdx - 1) + ')').text();	

				//点击时，构造项值数组
				var vCols = g.extraColIdx.split(',');
				for (var i = 0; i < vCols.length; i++) {
					vExtraVal.push(p.find('td:eq(' + parseInt(vCols[i]-1) + ')').text());
				};

			_setValue2(disValue, retValue);
			vCols.length > 0 && _setExtraValue();
		});
	};

	function _setExtraValue(isReset){
		var vItems = g.extraItems.split(',');
		for (var i = 0; i < vItems.length ; i++) {
			$x_Value(vItems[i],(isReset=='RESET'?'':vExtraVal[i]));
		};
	};
	function _setValue(d, r) {
		oHiddenInput.val(r);
		var oDisLabel = $('#' + pSelector + '_name');
		//显示ID与名称
		if (g.displayMode === 'ID_AND_NAME') {
			oDisLabel.text(d);
			oDisInput.val(r);
		} else {
			oDisInput.val(d);
		};
	};

	function _setValue2(dis,ret){
		_setValue(dis, ret);
		_hide();
		bValidVal = true;
		oDisInput.focus();

		var nChangeCnt = oDisInput.data("events")["change"].length;
		//属性conchage
		ret && oDisInput.attr('onchange') && nChangeCnt++;
		//nChangeCnt == 1，没有级联事件
		nChangeCnt >= 2 && oDisInput.trigger("change");
	};

	//重置分页
	function _resetPagination() {
		$('#' + pSelector + '_next').val() == 'N' ? oNext.hide() : oNext.show();
		$('#' + pSelector + '_prev').val() == 'N' ? oPrev.hide() : oPrev.show();
	};
	//下一页

	function _nextPage() {
		g.currentPage += 1;
		_fetchData();
	};
	//上一页

	function _prevPage() {
		g.currentPage -= 1;
		_fetchData();
	};

	function _hide() {
		if (g.isOpen) {
			oWrap.hide(); //slideToggle();
			g.isOpen = false;
		}
	};

	function _show() {
		if (!g.isOpen) {
			oWrap.show();
			//oWrap.css('top',nDisHeight).show();
			//打开缺省聚焦搜索框
			oSearch.focus();
			g.isOpen = true;
		}
	};

	function _refresh() {
		oWrap.trigger('apexrefresh');
	};

	function _beforeRefresh() {
		oWrap.trigger("apexbeforerefresh");
		oWrap.append('<span class="apex-loading-indicator"></span>');
		_fetchData(true);
		_afterRefresh();
	};

	function _afterRefresh() {
		oWrap.trigger("apexafterrefresh");
		$(".apex-loading-indicator", oWrap).remove();
	};
	//ID取名称

	function _fetchUniqeValue() {
		console.log('change');
		//从报表取值时，不再从数据库取值
		if (bValidVal) {
			bValidVal = false;
			return;
		};
		var v = oDisInput.val();
		//空值 显示
		if (v=='' && g.nullValue) {
			_setValue2(g.nullText, g.nullValue);
			return;
		};

		var j = $.extend({
				x01: 'TYPE',
				x04: v
			},
				oData);
		$.ajax({
			type: 'post',
			url: 'wwv_flow.show',
			dataType: 'json',
			async: true,
			data: j,
			success: function(data) {
				var a = data.info;
				//_status==1返回唯一值
				//_status==2返回多值

				if (a._status == 1) {
					//返回唯一值
					_setValue(a.name, a.id);

					//设置其他项的值
					for (var props in data.extraItems) {
						$x_Value(props,data.extraItems[props]);
					};

				} else {
					//清空值
					_setValue('', '');
					_setExtraValue('RESET');

					//==2为返回多值，把多值显示在列表
					a._status == 2 && (oSearch.val(v),sPrevSearchValue = v);

					//--0没有返回值，重新搜索
					a._status == 0 && (oSearch.val(''),sPrevSearchValue = '');

					_fetchData(true);
					_show();
					//聚焦
					oSearch.focus();
				}
			}
		});
	};

	//键盘点击事件
	function _choose() {
		var r = oRows.eq(nIndex),
			ret = r.find('td:eq(' + parseInt(g.retColIdx - 1) + ')').text(),
			dis = r.find('td:eq(' + parseInt(g.disColIdx - 1) + ')').text();

		if (r.size()) {
			_setValue2(dis, ret);
		}
	};

	function _keydown(evt) {
		switch (evt.keyCode) {
			case oKeys.esc:
				_hide();
				//fixes esc twice clears the textbox value bug in ie
				evt.preventDefault();
				return;
			case oKeys.enter:
				_choose();
				//don't submit the form
				evt.preventDefault();
				return;
				//case oKeys.tab:
				//_choose();
				//return;
			case oKeys.up:
				_goup();
				return;
			case oKeys.down:
				_godown();
				return;
		}
	};

	function _godown() {
		var n = oRows.size();
		if (!n) return;
		nIndex++;
		if (nIndex > n - 1) nIndex = 0;
		var v = oRows.eq(nIndex);
		if (v.size()) {
			_hilightRow(v);
		}
	};

	function _goup() {
		var n = oRows.size();
		if (!n) return;
		nIndex--;
		if (nIndex < 0) nIndex = n - 1;
		var v = oRows.eq(nIndex);
		if (v.size()) {
			_hilightRow(v);
		}
	};

	function _doKeydown() {

		oWrap.unbind('keydown').bind({
			keydown: function(event) {
				_keydown(event)
			}
		});
	};

	function _hilightRow(obj) {
		obj.addClass('over').siblings().removeClass('over')
	};

	//鼠标点击事件
	function _doMouseDown(e) {
		var c = e.target,
			d = $(c).closest(oWrap),
			b = $(c).hasClass('icon_close'),
			e = $(c).closest(oOpen);
		if (!(e.length || d.length)) {
			_hide();
		};
		b && _hide();
	};

	function _init() {
		//绑定keydown事件
		if (!g.isInit) {
			$(document).mousedown(_doMouseDown);
		};
		//级联刷新
		if (g.dependingOnSelector) {
			$(g.dependingOnSelector).change(_refresh)
		}
		//部分延迟处理
		setTimeout(function() {
			//搜索框绑定事件
			oSearch.keydown(function(e) {
				if ($f_Enter(e)) {
					//当搜索框的值与上一次查询的值不一样时，执行查询
					//否则事件向上冒泡，选定行并返回值 
					if (oSearch.val() != sPrevSearchValue) {
						sPrevSearchValue = oSearch.val();
						_fetchData(true);
						e.stopPropagation();
					};
				}
			});

			//注册ajax事件
			oWrap.bind('apexrefresh', _beforeRefresh);

			//注册分页事件
			oNext.unbind('click').bind('click', function(e) {
				_nextPage();
				e.stopPropagation();
			});
			oPrev.unbind('click').bind('click', function(e) {
				_prevPage();
				e.stopPropagation();
			});

			//调整下拉区域宽度
			oWrap.css('min-width', oDisInput.outerWidth() + oOpen.outerWidth());
		}, 500);

		//名称字段宽度
		oDisLabel.width(nDisWidth);

		//手工录入绑定事件
		oDisInput.change(function() {
			_fetchUniqeValue();
		});

		//
		oOpen.unbind('click').bind('click', function(e) {
			//没有初始化则取值
			!g.isInit && _fetchData(true);
			g.isInit && _initReport();
			_show();
			e.stopPropagation();
		});
	};

	// Initialized
	_init();
}