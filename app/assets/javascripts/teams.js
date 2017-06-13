$(document).ready(function() {

    $('.delete_team').bind('ajax:success', function() {
        $(this).closest('tr').fadeOut();
    });
});
