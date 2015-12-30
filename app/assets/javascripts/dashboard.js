$('#dashboard').ready(function() {
	var timeChart,
		equityChart;

	function loadMessages() {
		$.ajax('/dashboard/messages', {
			data: {
				id: window.location.pathname.split('/')[2],
				time: $('#time-range').data('time'),
				conversation: $('#conversation').data('conversation')
			},
			success: function(response) {
				if (timeChart) {
					timeChart.destroy();
				}
				timeChart = new Chart($("#time").get(0).getContext("2d")).Line({
					labels: response.labels,
					datasets: [{
						data: response.counts
					}]
				}, {
					showTooltips: false
				});
			}
		});
	}

	function loadEquity() {
		$.ajax('/dashboard/equity', {
			data: {
				id: window.location.pathname.split('/')[2],
				time: $('#time-range').data('time'),
				conversation: $('#conversation').data('conversation')
			},
			success: function(response) {
				new Chart($('#equity').get(0).getContext('2d')).Doughnut($.map(response.equities, function(element) {
					element.color = '#' + Math.floor(Math.random() * 16777215).toString(16);
					element.value = element.value.toFixed(2);
					return element;
				}));
				$('#equity-index').text("Total Messaging Equity Index: " + response.total.toFixed(2));
			}
		});
	}

	function loadCloud() {
		$.ajax('/dashboard/cloud', {
			data: {
				id: window.location.pathname.split('/')[2],
				conversation: $('#conversation').data('conversation')
			},
			success: function(response) {
				$('#cloud').empty();
				$('#cloud').jQCloud(response);
			}
		});
	}

	function loadData() {
		loadMessages();
		loadEquity();
		loadCloud();
	}

	$('#time-range li').on('click', function() {
		$('#time-range').data('time', $(this).find('a').attr('id'));
		$('#time-range button').html($(this).text() + "<span class='caret'></span>");

		loadData();
	});

	$('#conversation li').on('click', function() {
		$('#conversation').data('conversation', $(this).find('a').attr('id'));
		$('#conversation button').html($(this).text() + "<span class='caret'></span>");

		loadData();
	});

	loadData();
});