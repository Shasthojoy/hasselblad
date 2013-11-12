module.exports = App.StatItemComponent = Ember.Component.extend
    tagName: 'div'

    classNames: ['stat-item']

    filteredSnapshots: (->
        filter = @filter
        now = moment()
        nowFormatted = now.format('YYYY-MM-DD')

        _.filter @snapshots, (snapshot) ->
            if filter is 'today'
                moment(snapshot.date).format('YYYY-MM-DD') is nowFormatted
            else
                snapshot is snapshot
    ).property()

    didInsertElement: ->
        colors = ['blue', 'green', 'yellow', 'orange', 'red']
        @$().addClass colors[Math.floor(Math.random() * (5 - 0 + 0)) + 0]