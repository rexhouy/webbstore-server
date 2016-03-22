Chart.types.Line.extend({
        name: "DottedLine",
        initialize: function (data) {
                Chart.types.Line.prototype.initialize.apply(this, arguments);

                var ctx = this.chart.ctx;
                var originalBezierCurveTo = ctx.bezierCurveTo;
                var originalInitialize = ctx.initialize;
                ctx.bezierCurveTo = function () {
                        ctx.setLineDash([5, 3]);
                        originalBezierCurveTo.apply(this, arguments);
                };
        }
});


Chart.types.Line.extend({
        name: "LineAlt",
        initialize: function (data) {
                var strokeColors = [];
                data.datasets.forEach(function (dataset, i) {
                        if (dataset.dotted) {
                                strokeColors.push(dataset.strokeColor);
                                dataset.strokeColor = "rgba(0,0,0,0)";
                        }
                });

                Chart.types.Line.prototype.initialize.apply(this, arguments);

                var self = this;
                data.datasets.forEach(function (dataset, i) {
                        if (dataset.dotted) {
                                self.datasets[i].dotted = true;
                                self.datasets[i]._saved = {
                                        strokeColor: strokeColors.shift()
                                };
                        }
                });
        },
        draw: function () {
                Chart.types.Line.prototype.draw.apply(this, arguments);

                // from Chart.js library code
                var hasValue = function (item) {
                        return item.value !== null;
                },
                    nextPoint = function (point, collection, index) {
                            return Chart.helpers.findNextWhere(collection, hasValue, index) || point;
                    },
                    previousPoint = function (point, collection, index) {
                            return Chart.helpers.findPreviousWhere(collection, hasValue, index) || point;
                    };

                var ctx = this.chart.ctx;
                var self = this;
                ctx.save();
                this.datasets.forEach(function (dataset) {
                        if (dataset.dotted) {
                                ctx.lineWidth = self.options.datasetStrokeWidth;
                                ctx.strokeStyle = dataset._saved.strokeColor;

                                // adapted from Chart.js library code
                                var pointsWithValues = Chart.helpers.where(dataset.points, hasValue);
                                Chart.helpers.each(pointsWithValues, function (point, index) {
                                        if (dataset.dotted)
                                                ctx.setLineDash([3, 3]);
                                        else
                                                ctx.setLineDash([]);

                                        if (index === 0) {
                                                ctx.moveTo(point.x, point.y);
                                        }
                                        else {
                                                if (self.options.bezierCurve) {
                                                        var previous = previousPoint(point, pointsWithValues, index);
                                                        ctx.bezierCurveTo(
                                                                previous.controlPoints.outer.x,
                                                                previous.controlPoints.outer.y,
                                                                point.controlPoints.inner.x,
                                                                point.controlPoints.inner.y,
                                                                point.x,
                                                                point.y
                                                        );
                                                }
                                                else {
                                                        ctx.lineTo(point.x, point.y);
                                                }
                                        }

                                        ctx.stroke();
                                }, this);
                        }
                });
                ctx.restore();
        }
});
