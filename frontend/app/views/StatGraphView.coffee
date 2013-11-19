module.exports = App.StatGraphView = Ember.View.extend
    tagName: 'div'

    classNames: ['graph']

    attributeBindings: ['title']

    draw: (->
        $el = @$()
        title = @get 'title'
        snapshots = @get 'content'

        if snapshots and snapshots.length
            # To test data binding e.g. (App.dataTest.blimp_projects[6].set('value', 400))
            App.dataTest[title] = snapshots

            $el.empty()

            #d3 0_o
            m = [20, 20, 20, 20]
            w = ($el.width() - 20) - m[1] - m[3]
            h = ($el.height() + 10) - m[0] - m[2]
            parse = d3.time.format("%Y-%m-%dT%H:%M:%S.%LZ").parse
            tickFormat = d3.time.format("%-m/%d %-I%p")

            x = d3.time.scale().range([0, w])
            y = d3.scale.linear().range([h, 0])
            xAxis = d3.svg.axis().scale(x).tickSize(-h).tickFormat(tickFormat)
            yAxis = d3.svg.axis().scale(y).ticks(2).orient("right")

            area = d3.svg.area()
            .interpolate("linear")
            .x((snapshot) -> x(snapshot.get 'date'))
            .y0(h)
            .y1((snapshot) -> y(snapshot.get 'value'))

            line = d3.svg.line()
            .interpolate("linear")
            .x((snapshot) -> x(snapshot.get 'date'))
            .y((snapshot) -> y(snapshot.get 'value'))

            _.each snapshots, (snapshot) ->
                date = snapshot.get 'date'
                parsedDate = if _.isDate(date) then date else parse date
                snapshot.set 'date', parsedDate
                snapshot.set 'value', +(snapshot.get 'value')

            total = 0
            total += snapshot.get('value') for snapshot in snapshots

            x.domain([_.first(snapshots).get('date'), _.last(snapshots).get('date')])
            y.domain([0, d3.max(snapshots, (snapshot) -> snapshot.get 'value')]).nice()

            svg = d3.select($el[0]).append("svg:svg")
            .attr("width", w)
            .attr("height", h)
            .append("svg:g")
            .attr("transform", "translate(20,20)")

            svg.append("svg:path")
            .attr("class", "area")
            .attr("d", area(snapshots))

            svg.append("svg:g")
            .attr("class", "x axis")
            .attr("transform", "translate(1," + h + ")")
            .call(xAxis)

            svg.append("svg:g")
            .attr("class", "y axis")
            .attr("transform", "translate(" + w + ",0)")
            .call(yAxis)

            svg.selectAll("line.y")
            .data(y.ticks(2))
            .enter().append("line")
            .attr("x1", 0)
            .attr("x2", w)
            .attr("y1", y)
            .attr("y2", y)
            .style("stroke", "#fff")
            .style("stroke-opacity", 0.05)

            svg.append("svg:path")
            .attr("class", "line")
            .attr("d", line(snapshots))

            svg.append("svg:text")
            .attr("x", 80)
            .attr("y", -10)
            .attr("text-anchor", "end")
            .style("fill", "#fff")
            .style("stroke-width", .2)
            .style("font-size", "11px")
            .style("font-weight", "bold")

            svg.append("svg:text")
            .attr("x", w)
            .attr("y", -10)
            .attr("text-anchor", "end")
            .text("#{total} #{title}")
            .style("fill", "#fff")
            .style("stroke-width", .2)
            .style("font-size", "11px")
            .style("font-weight", "bold")

            svg.selectAll("circle")
            .data(snapshots)
            .enter().append("circle")
            .attr("r", 4)
            .attr('cx', (snapshot) -> x(snapshot.get 'date'))
            .attr('cy', (snapshot) -> y(snapshot.get 'value'))
    ).observes 'content.@each.value'

    didInsertElement: ->
        @draw()
