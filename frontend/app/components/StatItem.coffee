module.exports = App.StatItemComponent = Ember.Component.extend
    tagName: 'div'

    classNames: ['stat-item']

    didInsertElement: ->
        colors = ['blue', 'green', 'yellow', 'orange', 'red']
        @$().addClass colors[Math.floor(Math.random() * (5 - 0 + 0)) + 0]

        data = @get 'snapshots'
        title = @get 'name'
        $graph = @$ '.graph'

        # remove last element crap
        data.pop()

        #d3 0_o
        m = [80, 80, 80, 80]
        w = 470 - m[1] - m[3]
        h = 290 - m[0] - m[2]
        parse = d3.time.format("%Y-%m-%dT%H:%M:%S.%LZ").parse

        x = d3.time.scale().range([0, w])
        y = d3.scale.linear().range([h, 0])
        xAxis = d3.svg.axis().scale(x).tickSize(-h).tickFormat(d3.time.format("%-m/%d"))
        yAxis = d3.svg.axis().scale(y).ticks(2).orient("right")

        area = d3.svg.area()
        .interpolate("linear")
        .x((d) -> x(d.date))
        .y0(h)
        .y1((d) -> y(d.value))

        line = d3.svg.line()
        .interpolate("linear")
        .x((d) -> x(d.date))
        .y((d) -> y(d.value))

        data.forEach (d) ->
            d.date = parse(d.date)
            d.value = +d.value

        total = 0
        total += stat.value for stat in data

        x.domain([data[0].date, data[data.length - 1].date])
        y.domain([0, d3.max(data, (d) -> d.value)]).nice()

        svg = d3.select($graph[0]).append("svg:svg")
        .attr("width", w + m[1] + m[3])
        .attr("height", h + m[0] + m[2])
        .append("svg:g")
        .attr("transform", "translate(#{12}, #{5})")

        svg.append("svg:path")
        .attr("class", "area")
        .attr("d", area(data))

        svg.append("svg:g")
        .attr("class", "x axis")
        .attr("transform", "translate(1," + h + ")")
        .call(xAxis)

        svg.append("svg:g")
        .attr("class", "y axis")
        .attr("transform", "translate(" + w + ",0)")
        .call(yAxis)

        svg.selectAll("line.y")
        .data(y.ticks(5))
        .enter().append("line")
        .attr("x1", 0)
        .attr("x2", w)
        .attr("y1", y)
        .attr("y2", y)
        .style("stroke", "#000000")
        .style("stroke-opacity", 0.06)

        svg.append("svg:path")
        .attr("class", "line")
        .attr("d", line(data))

        svg.append("svg:text")
        .attr("x", 80)
        .attr("y", -10)
        .attr("text-anchor", "end")
        .text('Gross Volume')
        .style("stroke", "#444")
        .style("fill", "#000")
        .style("stroke-width", .2)
        .style("font-size", "12px")
        .style("font-weight", "bold")

        svg.append("svg:text")
        .attr("x", w)
        .attr("y", -10)
        .attr("text-anchor", "end")
        .text("#{total} #{title}")
        .style("stroke", "#008cdd")
        .style("fill", "#008cdd")
        .style("stroke-width", .2)
        .style("font-size", "12px")
        .style("font-weight", "bold")

        svg.selectAll("circle")
        .data(data)
        .enter().append("circle")
        .attr("r", 4)
        .attr('cx', (d) -> x(d.date))
        .attr('cy', (d) -> y(d.value))

