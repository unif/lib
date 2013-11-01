(function($) {
  $.fn.combobox = function(opt) {
    opt = $.extend({
      mainDiv: 'ui-widget-content',
      cbbClass: 'l-combobox',
      dialogId: null,
      retIdx: 0,
      trSelctor: ' div.bl-body table.default1 tr:gt(0)'
    },
    opt);
 
    var cbbDiv = $('#' + opt.dialogId);
    var cbbTr = $('#' + opt.dialogId + opt.trSelctor);
    var T = this;
 
    _showCbb = function(e) {
      var p = e.data.self,
      loc = {
        left: T.offset().left,
        top: T.offset().top + T.height() + 6,
        display: 'block'
      };
      cbbDiv.css(loc).addClass(' ' + opt.mainDiv + ' ' + opt.cbbClass);
 
      cbbTr.live('mouseenter',
      function() {
        $(this).addClass('over');
      }).live('mouseleave',
      function() {
        $(this).removeClass('over');
      }).die('click').live('click', {
        self: T
      },
      _handleTrClick);
 
      $(document).bind({
        mousedown: function(e) {
          _doMouseDown(e)
        }
      });
      T.bind('keydown',
      function(e) {
        _doKeyDown(e)
      });
    };
    _handleTrClick = function(o) {
      var p = o.data.self;
      var v = $(o.currentTarget).find('td:eq(' + opt.retIdx + ')').text();
      p.val(v).trigger('change');
      _hideCbb();
    };
    _hideCbb = function() {
      cbbDiv.removeClass(' ' + opt.mainDiv + ' ' + opt.cbbClass).css('display', 'none');
 
      $(document).unbind('mousedown', _doMouseDown);
      T.unbind('keydown', _doKeyDown);
    };
    _doKeyDown = function(e) {
      switch (e.keyCode) {
      case 9:
        _hideCbb();
        break;
      case 27:
        _hideCbb();
        break;
      }
    };
    _doMouseDown = function(e) {
      var c = e.target,
      d = $(c).closest('.' + opt.cbbClass);
      if (typeof(d[0]) != 'undefined') {
        d[0].id != opt.dialogId && _hideCbb();
      } else {
        c.id != T[0].id && _hideCbb();
      }
    };
    T.unbind('focus').bind('focus', {
      self: T
    },
    _showCbb);
  }
})(jQuery);