
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
  $(".users_row").droppable(
    {
      // users_row 内でDraggable 要素が置かれた時に再びドラッグ可能になるように
    }
  );

  var USER_NUMBER_SUM_ALBUM = 0; 
  $(".album-icon").droppable(
    {
      tolerance: 'fit',
      drop: function(e, ui) {
        USER_NUMBER_SUM_ALBUM += Number(ui.draggable.attr('id'));
      },
      out: function(e, ui) {
        USER_NUMBER_SUM_ALBUM -= Number(ui.draggable.attr('id'));
        if (USER_NUMBER_SUM_ALBUM < 0) {
          USER_NUMBER_SUM_ALBUM = 0;
        }
      }
    }
  );

  $(".album-icon").click(function(){
    location.href="/notes/search_index?user_number_sum=" + USER_NUMBER_SUM_ALBUM;
    return false;
  });

});
