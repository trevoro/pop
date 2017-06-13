$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

  $('.delete_post').bind('ajax:success', function() {
      $(this).closest('tr').fadeOut();
  });

  $('.work_item_team').change( function() {
      var selectedValue = $(this)[0].value;
          $(this).parents('form:first').submit();
  });

   var startDate;
   var endDate;

   var selectCurrentWeek = function() {
       window.setTimeout(function () {
           $('.week-picker').find('.ui-datepicker-current-day a').addClass('ui-state-active')
       }, 1);
   }


});
