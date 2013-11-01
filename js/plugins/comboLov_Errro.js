var comboLov = {
	g: {
		isOpen: false,
		isInit: false,
		dependingOnSelector: null,
		optimizeRefresh: true,
		pageItemsToSubmit: null,
		ajaxIdentifier: null,
		nullValue: null,
		retColIdx: 1,
		disColIdx: 2,
		currentPage: 1,
		maxRowsPerPage: 15,
		rows: '1:15',
		displayMode: 'NAME'
	},
	p: {
		id:null,
		nIndex: 0,
		sPrevSearchValue: '',
		bValidVal: false,
		oRows: {},
		oData: {},
		oKeys: {
			up: 38,
			down: 40,
			enter: 13,
			tab: 9,
			esc: 27
		}
	},
	oData: {},
	_initElem: function(){
		var s = this,
		a = s,
		i = a.id;
		a.oFieldSet = $('#' + i + '_fieldset');
		a.oWrap = $('#' + i + '_wrap');
		a.oWrapCont = $('.cont', a.oWrap);
		a.oNext = $('a.next', a.oWrap);
		a.oPrev = $('a.prev', a.oWrap);
		a.oToolBar = $('.toolbar', a.oWrap);
		a.oSearch = $('#' + i + '_search');
		a.oOpen = $('td.open', a.oFieldSet);
		a.oHiddenInput = $('#' + i + '_HIDDENVALUE');
		a.oDisInput = $('#' + i);
		a.oDisLabel = $('#' + i + '_name');
		a.oLov = $('td.lov', a.oFieldSet);
		a.nDisHeight = a.oLov.outerHeight();
		a.nDisWidth = a.oLov.outerWidth();
		a.oData.p_request = "NATIVE=" + s.g.ajaxIdentifier;
		a.oData.p_flow_id = $v("pFlowId");
		a.oData.p_flow_step_id = $v("pFlowStepId");
		a.oData.p_instance = $v("pInstance");
	},
	_fetchData: function(newPgn) {
		var s = this,
		a = s,
		c = s.g;
		if (!newPgn) {
			var b = (c.currentPage - 1) * c.maxRowsPerPage + 1,
				e = c.currentPage * c.maxRowsPerPage;
			c.newRows = b + ':' + e;
		} else {
			a.newRows = c.rows;
			a.oPrev.hide();
		}

		var j = $.extend({
			p_arg_names: [],
			p_arg_values: [],
			x02: c.newRows,
			x04: a.oSearch.val()
		},
			c.oData);
		//级联项和提交项
		$(c.dependingOnSelector).add(c.pageItemsToSubmit).each(function(index) {
			j.p_arg_names[index] = this.id;
			j.p_arg_values[index] = $v(this)
		});

		$.ajax({
			type: 'post',
			url: 'wwv_flow.show',
			data: j,
			success: function(data) {
				a.oWrapCont.html(data);
				//绑定报表行点击事件
				s._handdleRowClick();
				//重置分页
				s._resetPagination();
				//绑定事件
				s._doKeydown();
				c.isInit = true;
			}
		});
	},
	_initReport: 	function (){
		var s = this,
		b = false,
		oReport = $('#' + s.id + '_report');
		s.oRows = $('tbody tr', oReport);

		//hightline 已选
		s.oRows.each(function(index) {
			var r = $(this),
				ret = r.find('td:eq(' + parseInt(s.g.retColIdx - 1) + ')').text();
			if (ret == s.oDisInput.val()) {
				s._hilightRow(r);
				b = true;
				s.nIndex = index;
			};
		});
		//当前页没有选中的行
		b || (s.nIndex = -1);
	},
	_handdleRowClick: function() {
		var s = this;
		s._initReport();
		s.oRows.die('click').live('click', function(e) {
			var c = $(this),
				ret = c.find('td:eq(' + parseInt(s.g.retColIdx - 1) + ')').text(),
				dis = c.find('td:eq(' + parseInt(s.g.disColIdx - 1) + ')').text();
			s._setValue2(dis, ret);
		});
	},
	_setValue: function(d, r) {
		var s = this;
		s.oHiddenInput.val(r);
		//var oDisLabel = $('#' + s.id + '_name'); 混淆？
		//显示ID与名称
		if (s.g.displayMode === 'ID_AND_NAME') {
			s.oDisLabel.text(d);
			s.oDisInput.val(r);
		} else {
			s.oDisInput.val(d);
		};
	},
	_setValue2: function(dis, ret) {
		var s = this;
		s._setValue(dis, ret);
		s._hide();
		s.bValidVal = true;
		s.oDisInput.focus();

		var nChangeCnt = s.oDisInput.data("events")["change"].length;
		ret && s.oDisInput.attr('onchange') && nChangeCnt++;
		//nChangeCnt == 1，没有级联事件
		nChangeCnt >= 2 && s.oDisInput.trigger("change");
	},

	//重置分页
	_resetPagination: function() {
		var s = this;
		$('#' + s.id + '_next').val() == 'N' ? s.oNext.hide() : s.oNext.show();
		$('#' + s.id + '_prev').val() == 'N' ? s.oPrev.hide() : s.oPrev.show();
	},
	//下一页

	_nextPage: function() {
		this.g.currentPage += 1;
		this._fetchData();
	},
	//上一页

	_prevPage: function() {
		this.g.currentPage -= 1;
		this._fetchData();
	},
	_hide: function() {
		if (this.g.isOpen) {
			this.oWrap.hide(); //slideToggle();
			this.g.isOpen = false;
		}
	},
	_show: function() {
		if (!this.g.isOpen) {
			this.oWrap.show();
			//oWrap.css('top',nDisHeight).show();
			//打开缺省聚焦搜索框
			this.oSearch.focus();
			this.g.isOpen = true;
		}
	},

	_refresh: function() {
		this.oWrap.trigger('apexrefresh');
	},

	_beforeRefresh: function() {
		this.oWrap.trigger("apexbeforerefresh");
		this.oWrap.append('<span class="apex-loading-indicator"></span>');
		this._fetchData(true);
		this._afterRefresh();
	},

	_afterRefresh: function() {
		this.oWrap.trigger("apexafterrefresh");
		$(".apex-loading-indicator", this.oWrap).remove();
	},
	//ID取名称

	_fetchUnqValue: function() {
		var s = this,
		a = s;
		//从报表取值时，不再从数据库取值
		if (a.bValidVal) {
			a.bValidVal = false;
			return;
		};
		var v = a.oDisInput.val(),
			j = $.extend({
				x01: 'TYPE',
				x04: v
			},
			a.oData);

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
					s._setValue(a.name, a.id);
				} else {
					//清空值
					s._setValue('', '');
					//==2为返回多值，把多值显示在列表
					a._status == 2 && (a.oSearch.val(v), a.sPrevSearchValue = v);

					//--0没有返回值，重新搜索
					a._status == 0 && (a.oSearch.val(''), a.sPrevSearchValue = '');

					s._fetchData(true);
					s._show();
					//聚焦
					a.oSearch.focus();
				}
			}
		});
	},
	//键盘点击事件

	_choose: function() {
		var s = this,
		r = s.oRows.eq(nIndex),
			ret = r.find('td:eq(' + parseInt(s.g.retColIdx - 1) + ')').text(),
			dis = r.find('td:eq(' + parseInt(s.g.disColIdx - 1) + ')').text();

		if (r.size()) {
			s._setValue2(dis, ret);
		}
	},

	_keydown: function(evt) {
		var s = this;
		switch (evt.keyCode) {
			case s.oKeys.esc:
				s._hide();
				//fixes esc twice clears the textbox value bug in ie
				evt.preventDefault();
				return;
			case s.oKeys.enter:
				s._choose();
				//don't submit the form
				evt.preventDefault();
				return;
				//case oKeys.tab:
				//_choose();
				//return;
			case s.oKeys.up:
				s._goup();
				return;
			case s.oKeys.down:
				s._godown();
				return;
		}
	},

	_godown: function() {
		console.log(oRows[0].parentNode.parentNode.id);
		var s = this,
		a = s,
		n = s.oRows.size();
		if (!n) return;
		a.nIndex++;
		if (a.nIndex > n - 1) a.nIndex = 0;
		var v = a.oRows.eq(a.nIndex);
		if (v.size()) {
			s._hilightRow(v);
		}
	},

	_goup: function() {

		var s = this,
		a = s,
		n = a.oRows.size();
		if (!n) return;
		a.nIndex--;
		if (a.nIndex < 0) a.nIndex = n - 1;
		var v = a.oRows.eq(a.nIndex);
		if (v.size()) {
			s._hilightRow(v);
		}
	},

	_doKeydown: function() {
		var s = this,
		a = s,
		b = false;

		//hightline 已选
		a.oRows.each(function(index) {
			var r = $(this),
				ret = r.find('td:eq(' + parseInt(s.g.retColIdx - 1) + ')').text();
			if (ret == a.oDisInput.val()) {
				s._hilightRow(r);
				b = true;
				a.nIndex = index;
			};
		});

		b || (a.nIndex = -1);
		//_hilightRow(oRows.eq(nIndex));	

		a.oWrap.unbind('keydown').bind({
			keydown: function(event) {
				s._keydown(event)
			}
		});
	},

	_hilightRow: function(obj) {
		obj.addClass('over').siblings().removeClass('over')
	},
	//鼠标点击事件
	_doMouseDown: function(e) {
		var s = this,
		c = e.target,
		d = $(c).closest(s.oWrap),
		b = $(c).hasClass('icon_close'),
		e = $(c).closest(s.oOpen);
		if (!(e.length || d.length)) {
			s._hide();
		};
		b && s._hide();
	},

	_create: function() {
		//绑定keydown事件
		var s = this,
		a = s;
		if (!s.g.isInit) {
			$(document).mousedown(s._doMouseDown);
		};
		//级联刷新
		if (s.g.dependingOnSelector) {
			$(s.g.dependingOnSelector).change(s._refresh)
		}
		//部分延迟处理
		setTimeout(function() {
			//搜索框绑定事件
			a.oSearch.keydown(function(e) {
				if ($f_Enter(e)) {
					//当搜索框的值与上一次查询的值不一样时，执行查询
					//否则事件向上冒泡，选定行并返回值 
					if (a.oSearch.val() != a.sPrevSearchValue) {
						a.sPrevSearchValue = a.oSearch.val();
						s._fetchData(true);
						e.stopPropagation();
					};
				}
			});

			//注册ajax事件
			a.oWrap.bind('apexrefresh', s._beforeRefresh);

			//注册分页事件
			a.oNext.unbind('click').bind('click', function(e) {
				s._nextPage();
				e.stopPropagation();
			});
			a.oPrev.unbind('click').bind('click', function(e) {
				s._prevPage();
				e.stopPropagation();
			});

			//调整下拉区域宽度
			a.oWrap.css('min-width', a.oDisInput.outerWidth() + a.oOpen.outerWidth());
		}, 500);

		//名称字段宽度
		a.oDisLabel.width(a.nDisWidth);

		//手工录入绑定事件
		a.oDisInput.change(function() {
			s._fetchUnqValue();
		});

		a.oOpen.unbind('click').bind('click', function(e) {
			!s.g.isInit && s._fetchData(true);
			s.g.isInit && s._initReport();
			s._show();
			e.stopPropagation();
		});
	},
	init: function(pSelector, opt) {
		var s = this;
		s.g = $.extend(s.g, opt);
		s.id = pSelector;
		s._initElem();
		s._create();
	}
}