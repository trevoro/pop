$(document).ready(function() {
	$('.delete_screenshot').bind('ajax:success', function() {
		 $(this).closest('tr').fadeOut();
	});
});
