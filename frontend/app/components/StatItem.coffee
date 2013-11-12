module.exports = App.StatItemComponent = Ember.Component.extend
    tagName: 'div'

    classNames: ['stat-item']

    filteredSnapshots: (->
        filter = @get 'filter'
        filterFunction = ->

        switch filter
            when 'today'
                filterFunction = (snapshot) ->
                    today = moment().format 'YYYY-MM-DD'
                    moment(snapshot.date).format('YYYY-MM-DD') is today
            when 'yesterday'
                filterFunction = (snapshot) ->
                    d = new Date()
                    d.setDate d.getDate() - 1
                    yesterday = moment(d).format 'YYYY-MM-DD'
                    moment(snapshot.date).format('YYYY-MM-DD') is yesterday
            else
                filterFunction = -> true

        filteredSpanshots = _.filter @get('snapshots'), filterFunction
        _.map filteredSpanshots, (snapshot) -> Ember.Object.create snapshot
    ).property()

    didInsertElement: ->
        colors = ['blue', 'green', 'yellow', 'orange', 'red']
        @$().addClass colors[Math.floor(Math.random() * (5 - 0 + 0)) + 0]


