/*
 *	Purpose  :	切换显示或隐藏区域
 *	Author   :	
 *	Created  :	2012-1-8
 *	Upadated :	2012-1-8
 */
function toggleRegion() {
  var g = {
	  op:"l-toggle-open",
	  opo:"l-toggle-open-over",
	  cl:"l-toggle-close",
	  clo:"l-toggle-close-over",
	  selector:".l-toggle",
      heading:".toggleHeading"
  };

$(g.selector).hover(function() {
    var p = $(this);
    if (p.hasClass(g.op)) {
      p.addClass(g.opo);
    } else if (p.hasClass(g.cl)) {
      p.addClass(g.clo);
    }
  },
  function() {
    var p = $(this);
    if (p.hasClass(g.op)) {
      p.removeClass(g.opo);
    } else if (p.hasClass(g.cl)) {
      p.removeClass(g.clo);
    }
  });
  
  $(g.heading).click(function(event){
    var h = $(this);
    h.next().slideToggle("nomal");
    var p = $(g.selector, h);
    if (p.hasClass(g.op)) {
      p.removeClass(g.op+" "+g.opo).addClass(g.cl);
    } else {
      p.removeClass(g.cl+" "+g.op).addClass(g.op);
    }
  });
}


/*
 *	Purpose  :	左侧二级菜单显示
 *	Author   :	
 *	Created  :	2012-4-26
 *	Upadated :	2012-4-26
 */

(function() {
  $.fn.leftMenu = function(o) {
    o = $.extend({
      listClass: 'l-lm-list',
      smClass: 'l-lm-sm',
      leftAdj: 160,
      topAdj: 30,
      minw: 260,
      minh: 320,
      ltFixed: true
    },
    o);
    this.each(function() {
      var p = $(this),
      left = p.offset().left + o.leftAdj,
      top = p.offset().top - o.topAdj;

      p.find('li').hover(function() {
        if (!o.ltFixed) {
          left = $(this).offset().left + o.leftAdj,
          top = $(this).offset().top - o.topAdj;
        }
        $(this).addClass(o.listClass).find('.' + o.smClass).css({
          left: left,
          top: top,
          minWidth: o.minw,
          minHeight: o.minh
        }).show();
      },
      function() {
        $(this).removeClass(o.listClass).find('.' + o.smClass).hide();
      });

    });
  };
})(jQuery);