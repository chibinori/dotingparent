
$(function() {
  // .search-iconをdrag,drop可能に
  $(".search-icon").draggable(
    {
      revert: true
    }
  );
  $(".search-icon").droppable(
    {
      tolerance: 'pointer',
      drop: function(e, ui) {
        $(this).html($(this).html() +
          ui.draggable.attr('id') + 'が' + this.id + 'にドロップされました。<br />');
        
        var user_number_sum = Number(ui.draggable.attr('id')) + Number(this.id);
        location.href="/notes/search_index?user_number_sum=" + user_number_sum;
      }
    }
  );
});
