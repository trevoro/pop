$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

  $('.delete_report').bind('ajax:success', function() {
      $(this).closest('tr').fadeOut();
  });

});
