
$(function() {
  // .search-iconをdrag,drop可能に
  $(".search-icon").draggable(
    {
      //revert: true
    }
  );
  $(".search-icon").droppable(
    {
      tolerance: 'pointer',
      drop: function(e, ui) {
        //$(this).html($(this).html() +
        //  ui.draggable.attr('id') + 'が' + this.id + 'にドロップされました。<br />');
        
        var user_number_sum = Number(ui.draggable.attr('id')) + Number(this.id);
        location.href="/notes/search_index?user_number_sum=" + user_number_sum;
      }
    }
  );

  $(".search-icon").click(function(){
    location.href="/notes/search_index?user_number_sum=" + this.id;
    return false;
  });

  var USER_NUMBER_SUM_ALBUM = 0; 
  $(".album-icon").droppable(
    {
      tolerance: 'fit',
      drop: function(e, ui) {
        USER_NUMBER_SUM_ALBUM += Number(ui.draggable.attr('id'));
        $(this).html($(this).html() +
          ui.draggable.attr('id') + 'が' + 'アルバムにドロップされました。現在の番号 : '+ USER_NUMBER_SUM_ALBUM +  '<br />');
      },
      over: function(e, ui) {
        USER_NUMBER_SUM_ALBUM -= Number(ui.draggable.attr('id'));
        if (USER_NUMBER_SUM_ALBUM < 0) {
          USER_NUMBER_SUM_ALBUM = 0;
        }
        $(this).html($(this).html() +
          ui.draggable.attr('id') + 'が' + 'アルバムから出ました。現在の番号 : '+ USER_NUMBER_SUM_ALBUM +  '<br />');
      }
    }
  );

  $(".album-icon").click(function(){
    location.href="/notes/search_index?user_number_sum=" + USER_NUMBER_SUM_ALBUM;
    return false;
  });

});
