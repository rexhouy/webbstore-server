json.labels(@hists.map { |hist|
	graph_datetime hist.created_at
})
json.datasets([{
	                 label: "价格历史",
	                 fillColor: "rgba(151,187,205,0.2)",
	                 strokeColor: "rgba(151,187,205,1)",
	                 pointColor: "rgba(151,187,205,1)",
	                 pointStrokeColor: "#fff",
	                 pointHighlightFill: "#fff",
	                 pointHighlightStroke: "rgba(151,187,205,1)",
	                 data: @hists.map { |hist|
		                 current_user.location.eql?("北京市") ? hist.price_bj : hist.price_km
	                 }
                 }])
