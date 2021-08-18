var ResultsGraph = function (resultsGraphDataJson) {
    var $container = $("#results-graph"),
        $tooltip = $('#results-tooltip');

    var resultsGraphData = JSON.parse(resultsGraphDataJson);

    if ($.isEmptyObject(resultsGraphData)) {
        return false;
    }


    var beginOn = resultsGraphData.beginOn,
        endOn = resultsGraphData.endOn,
        results = resultsGraphData.results;

    var width = $container.width(),
        height = $container.height();

    var parseDate = d3.time.format("%Y-%m-%d").parse;

    var svg = d3.select("#results-graph").append("svg")
        .attr("width", width)
        .attr("height", height)
        .append("g");

    this.plot = function () {
        prepareData(results);

        var xScale = d3.time.scale()
            .domain([parseDate(beginOn), parseDate(endOn)])
            .range([10, width - 10]);

        var yScale = d3.scale.linear()
            .domain([-5, 105])
            .range([height, 0]);

        plotGrid(yScale);
        plotPoints(xScale, yScale);
    };

    function prepareData(data) {
        _.each(data, function (d) {
            d.date = parseDate(d.date);
        });
    }

    function plotGrid(yScale) {
        var yAxis = d3.svg.axis()
            .scale(yScale)
            .orient("left")
            .ticks(4)
            .innerTickSize(-width)
            .outerTickSize(0);


        svg.append("g")
            .attr("class", "y axis")
            .call(yAxis);
    }

    function plotPoints(xScale, yScale) {
        svg.selectAll(".point")
            .data(results)
            .enter().append("svg:circle")
            .attr("stroke", function (d) {
                return getColor(d);
            })
            .attr("fill", function (d) {
                return getColor(d);
            })
            .attr("cx", function (d) {
                return xScale(d.date)
            })
            .attr("cy", function (d) {
                return yScale(d.percent)
            })
            .attr("r", "4.5")
            .on('click', function (d) {
                showPointInfo(d)
            })
            .on('mouseover', function (d) {
                showPointTooltip(d, xScale, yScale);
            })
            .on('mouseout', function (d) {
                hidePointTooltip();
            });
    }

    function getColor(point) {
        if (point.passed) {
            return '#78c25f';
        } else {
            return '#b02048'
        }
    }

    function showPointInfo(point) {
        $.get(Routes.admin_my_student_result_path(point.studentId, point.resultId), function (response) {
            $('#current-result').html(response.result);
        });
    }

    function showPointTooltip(point, xScale, yScale) {
        $tooltip.find('.date').text(point.date.toLocaleDateString('ru-Ru'));
        $tooltip.find('.description').text(point.description);

        $tooltip.css('left', (d3.event.pageX - ($tooltip.width() / 2)) + 'px');

        svg.append('line').
            attr('x1', function () {
                return xScale(point.date);
            })
            .attr('x2', function () {
                return xScale(point.date)
            })
            .attr('y1', function () {
                return yScale(point.percent)
            })
            .attr('y2', height)
            .attr('stroke', function () {
                return getColor(point)
            })
            .attr('stroke-width', '3')
            .attr('id', 'tooltip-line');

        $tooltip.show();
    }

    function hidePointTooltip() {
        $tooltip.hide();
        $('#tooltip-line').remove();
    }
};