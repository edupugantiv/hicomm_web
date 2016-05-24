function markAsRead(event){
	$.ajax('/notifications/mark_as_read', {
		type: 'put',
		data: {
			notification_id: $(event.target).attr('class').split(' ')[0].replace('mark-as-read', '')
		},
		success: function(response) {
			var notification_id = $(event.target).attr('class').split(' ')[0].replace('mark-as-read', '')
			$('.mark-as-read'+notification_id).addClass('hide')
			$(event.target).parent().addClass('notification-body-read')

		}
	});
}

function markAllAsRead(event){
	$.ajax('/notifications/mark_all_as_read', {
		type: 'put',

		success: function(response) {

			$('.mark-as-read').addClass('hide')
			$('.notification-body-not-read').addClass('notification-body-read')

		}
	});
}
