json.labels(@labels)
datasets = [{
	                 label: "最低价",
	                 fillColor: "rgba(151,187,205,0)",
	                 strokeColor: "#ddd",
	                 pointColor: "#ddd",
	                 pointHighlightStroke: "#ddd",
                         dotted: true,
	                 data: @hists.map { |hist|
                             @product.min_price
	                 }
},
{
	                 label: "最高价",
	                 fillColor: "rgba(151,187,205,0)",
	                 strokeColor: "#ddd",
	                 pointColor: "#ddd",
	                 pointStrokeColor: "#fff",
	                 pointHighlightFill: "#fff",
	                 pointHighlightStroke: "#ddd",
                         dotted: true,
	                 data: @hists.map { |hist|
                             @product.max_price
	                 }
}]

colors = ["#f7464A", "#46BFBD", "#FDB45C", "#949FB1", "#4D5360"]
highlight_colors = ["#FF5A5E", "#5AD3D1", "#FFC870", "#A8B3C5", "#616774"]
index = 0
@hists_by_spec.each do |k, v|
        datasets << {
	                 label: k,
	                 fillColor: "rgba(151,187,205,0)",
	                 strokeColor: colors[index % 5],
	                 pointColor: colors[index % 5],
	                 pointStrokeColor: "#fff",
	                 pointHighlightFill: "#fff",
	                 pointHighlightStroke: highlight_colors[index % 5],
	                 data: v.map { |hist|
		                 current_user.location.eql?("北京市") ? hist[:price_bj] : hist[:price_km]
	                 }
         }
         index+=1
end

json.datasets(datasets)
