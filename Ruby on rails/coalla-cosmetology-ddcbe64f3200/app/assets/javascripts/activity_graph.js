var ActivityGraph = function (activityGraphDataJson, customContainerSelector) {
    var $container = $("#activity-graph");

    var isCustomContainer = !(typeof customContainerSelector === "undefined");

    var activityGraphData = JSON.parse(activityGraphDataJson);

    if ($.isEmptyObject(activityGraphData)) {
        return false;
    }

    var beginOn = activityGraphData.beginOn,
        endOn = activityGraphData.endOn,
        spentTime = activityGraphData.spentTime,
        results = activityGraphData.results;

    var width = $container.width(),
        height = null;

    if (isCustomContainer) {
        height = $(customContainerSelector).height();
    } else {
        height = $container.height();
    }

    var parseDate = d3.time.format("%Y-%m-%d").parse;

    var svg = d3.select("#activity-graph").append("svg")
        .attr("width", width)
        .attr("height", height)
        .append("g");

    this.plot = function () {
        prepareData(spentTime);

        var minX = parseDate(beginOn);

        if (isCustomContainer) {
            minX = minX.setHours(minX.getHours() - 4)
        }

        var xScale = d3.time.scale()
            .domain([minX, parseDate(endOn)])
            .range([0, width]);

        var maxY = d3.max(spentTime, function (d) {
                return d.hours;
            }) + 0.5;

        if (isCustomContainer) {
            maxY = maxY * 3;
        }

        var yScale = d3.scale.linear()
            .domain([0, maxY])
            .range([height, 0]);

        plotGradient();
        plotGrid(xScale, yScale);

        plotAreaChart(xScale, yScale);

        prepareData(results);
        plotPoints(xScale, yScale);
    };

    function prepareData(data) {
        _.each(data, function (d) {
            d.date = parseDate(d.date);
            d.hours = d.hours / 3600;
        });
    }

    function plotGrid(xScale, yScale) {
        var xAxis = d3.svg.axis()
            .scale(xScale)
            .orient("bottom")
            .ticks(4)
            .innerTickSize(-height)
            .outerTickSize(0);

        var yAxis = d3.svg.axis()
            .scale(yScale)
            .orient("left")
            .ticks(isCustomContainer ? 8 : 4)
            .innerTickSize(-width)
            .outerTickSize(0);

        svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis);

        svg.append("g")
            .attr("class", "y axis")
            .call(yAxis);
    }

    function plotAreaChart(xScale, yScale) {
        var area = d3.svg.area()
            .x(function (d) {
                return xScale(d.date);
            })
            .y0(height)
            .y1(function (d) {
                return yScale(d.hours);
            });

        svg.append("path")
            .datum(spentTime)
            .attr("class", "area")
            .attr('fill', 'url(#activity-gradient)')
            .attr("d", area);
    }

    function plotPoints(xScale, yScale) {
        svg.selectAll(".point")
            .data(results)
            .enter().append("svg:circle")
            .attr("stroke", "black")
            .attr("fill", "black")
            .attr("cx", function (d) {
                return xScale(d.date)
            })
            .attr("cy", function (d) {
                return yScale(d.hours)
            })
            .attr("r", "3");
    }

    function plotGradient() {
        svg.append('defs').append("linearGradient")
            .attr("id", "activity-gradient")
            .attr("gradientUnits", 'userSpaceOnUse')
            .attr("x1", '0%').attr("y1", '0%')
            .attr("x2", '100%').attr("y2", '0%')
            .selectAll("stop")
            .data([
                {offset: "0%", color: "#b02048"},
                {offset: "100%", color: "#b02097"}
            ])
            .enter().append("stop")
            .attr("offset", function (d) {
                return d.offset;
            })
            .attr("style", function (d) {
                return "stop-color:" + d.color + ';stop-opacity:2';
            });
    }

};
