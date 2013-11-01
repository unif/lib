var CTM_Menu = {
	dialogTitle:'菜单',
	oCtm:{},
	oCtmAll:{},
	getData: function(pRequest){
		return {
			p_flow_id: $v('pFlowId'),
	        p_flow_step_id: $v('pFlowStepId'),
	        p_instance: $v('pInstance'),
	        p_request: "APPLICATION_PROCESS=" + pRequest
	    }
	},
	init:function(){
		this.oCtm = $('#ctm_menu');
		this.oCtmAll = $('#ctm_menu_all');
	},
	putCtmMenu:function(){
		var p = this;
		$.ajax({
            type: 'post',
            url: 'wwv_flow.show',
            data: p.getData('putCtmMenu'),     
			async: true,
            success: function(data) {
				p.oCtm.html(data)
            },
			error: function(XMLHttpRequest, textStatus, errorThrown){
				console.log('CTM_Menu.putCtmMenu'+textStatus);
			}
        });
	},
	saveMenu:function(){
		var p = this,
			vList = [];
			$('input[type=checkbox]',p.oCtmAll).each(function(){
				this.checked && vList.push($(this).val())
			});
		$.ajax({
            type: 'post',
            url: 'wwv_flow.show',
            data: $.extend({
                x01: vList.join(',')      
			},p.getData('saveCtmMenu')),
			async: true,
            success: function(data) {
				p.putCtmMenu()
            },
			error: function(XMLHttpRequest, textStatus, errorThrown){
				console.log('CTM_Menu.saveMenu'+textStatus);
			}
        });	
	},
	putMenu:function(pwidth){
		var p = this;
		p.init();
		var d = p.oCtmAll;
		if (d.length>0) {
			d.dialog('open');
			return;
		};	
		$.ajax({
            type: 'post',
            url: 'wwv_flow.show',
            data: p.getData('putMenu'),
			async: true,
            success: function(data) {
				p.oCtm.append(data);
				p.init();
				d = p.oCtmAll;
				d.dialog({
					modal:false,
					title:p.dialogTitle,
					width:pwidth,
					hide:'slide',
					buttons:[{
						text:'设置',
						click:function(){
							p.saveMenu();
							d.dialog('close')
						}
					},{
						text:'取消',
						click:function(){d.dialog('close')}	
					}]

				});
				$('dd div',d).click(function(){
					var a = $(this),
						b = a.hasClass('checked');
					if (b) {
						a.removeClass('checked');
						$('input',a).removeAttr('checked')
					}else{
						a.addClass('checked');
						$('input',a).attr('checked','checked')
					}
				});
				d.dialog('open');
            },
			error: function(XMLHttpRequest, textStatus, errorThrown){
				console.log('CTM_Menu.putMenu'+textStatus);
			}
        });	
	}
};
