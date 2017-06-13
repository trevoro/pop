$(document).ready(function() {
	$('#team-update-modal').modal();

	$('.delete_update').bind('ajax:success', function() {
		 $(this).closest('tr').fadeOut();
	});
});

$(function() {
    var startDate;
    var endDate;

    var selectCurrentWeek = function() {
        window.setTimeout(function () {
            $('.team-update-week-picker').find('.ui-datepicker-current-day a').addClass('ui-state-active')
        }, 1);
    }

    $('.team-update-week-picker').datepicker( {

        onSelect: function(dateText, inst) {
            var date = $(this).datepicker('getDate');
            startDate = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay() + 1);
            var dateFormat = 'dd-mm-yy';
            $('#team_update_week').val(getWeek(new Date(startDate)));
            $('#team_update_year').val(getWeekYear(new Date(startDate)));


            selectCurrentWeek();
        },
        beforeShowDay: function(date) {
            var cssClass = '';
            if(date >= startDate && date <= endDate)
                cssClass = 'ui-datepicker-current-day';
            return [true, cssClass];
        },
        onChangeMonthYear: function(year, month, inst) {
            selectCurrentWeek();
        }
    });
});

$(function(){
    $('#team_update_modal').on('submit', function(e){
        e.preventDefault();
        $.ajax({
            url: "/team_updates", //this is the submit URL
            type: 'POST',
            data: $('#new_team_update').serialize(),
            success: function(data){
					  $('#team_update_modal_dismiss').click();
					  location.reload();
            }
        });
    });
});
