module.exports = App.StatItemComponent = Ember.Component.extend
    tagName: 'div'

    classNames: ['stat-item']

    filterIsToday: true

    filterSnapshots: (filter = @get 'filter') ->
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
            when 'week'
                filterFunction = (snapshot) ->
                    d = new Date()
                    d.setDate d.getDate() - 8
                    week = moment(d).format 'YYYY-MM-DD'
                    date = moment(snapshot.date).format 'YYYY-MM-DD'
                    moment(date).isAfter week
            when 'month'
                filterFunction = (snapshot) ->
                    #months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
                    d = new Date()
                    d.setDate d.getDate() + 1
                    d.setMonth d.getMonth() - 1
                    month = moment(d).format 'YYYY-MM-DD'
                    date = moment(snapshot.date).format 'YYYY-MM-DD'
                    moment(date).isAfter month
            else
                filterFunction = -> true

        filteredSpanshots = _.filter @get('snapshots'), filterFunction
        _.map filteredSpanshots, (snapshot) -> Ember.Object.create snapshot

    getLastSnapshotDate: ->
        last = _.last @get 'filteredSnapshots'
        if last then last.get('date') else ''

    checkSnapshotsAvailable: ->
        @get('filteredSnapshots').length > 0

    filteredSnapshots: (->
        @filterSnapshots()
    ).property()

    lastSnapshotDate: (->
        @getLastSnapshotDate()
    ).property()

    snapshotsAvailable: (->
        @checkSnapshotsAvailable()
    ).property()

    onSnapshotsFiltered: (->
        @set 'lastSnapshotDate', @getLastSnapshotDate()
        @set 'snapshotsAvailable', @checkSnapshotsAvailable()
    ).observes('filteredSnapshots')

    didInsertElement: ->
        colors = ['turquoise', 'emerald', 'greensea', 'nephritis',
            'peterriver', 'belizehole',
            'amethyst', 'wisteria',
            'wetasphalt', 'midnightblue',
            'sunflower', 'orange', 'carrot', 'pumpkin',
            'alizarin', 'pomegranate',
            'concrete', 'asbestos']

        @$().addClass colors[_.random 0, 17]

    actions:
        filter: (type) ->
            @set 'filterIsToday', false
            @set 'filterIsYesterday', false
            @set 'filterIsWeek', false
            @set 'filterIsMonth', false
            @set "filterIs#{type.charAt(0).toUpperCase() + type.slice 1}", true

            @set 'filter', type
            @set 'filteredSnapshots', @filterSnapshots()
