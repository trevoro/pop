$(function (){
	$('.delete_project').bind('ajax:success', function() {
    	$(this).closest('tr').fadeOut();
	});

	 // handle the mouseenter functionality
    $(".effects .person-img").mouseenter(function(){
        $(this).addClass("hover");
    })
    // handle the mouseleave functionality
    .mouseleave(function(){
        $(this).removeClass("hover");
    });
});
