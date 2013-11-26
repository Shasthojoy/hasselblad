module.exports = App.StatItemComponent = Ember.Component.extend
    tagName: 'div'

    classNames: ['stat-item']

    filterIsToday: yes

    stats: (->
        _.map @get('snapshots'), (snapshot) -> Ember.Object.create snapshot
    ).property('snapshots')

    lastSnapshotDate: (->
        last = _.last @get 'stats'
        if last then last.get('date') else ''
    ).property()

    didInsertElement: ->
        colors = [
            'turquoise', 'emerald', 'greensea', 'nephritis',
            'peterriver', 'belizehole',
            'amethyst', 'wisteria',
            'wetasphalt', 'midnightblue',
            'sunflower', 'orange', 'carrot', 'pumpkin',
            'alizarin', 'pomegranate',
            'concrete', 'asbestos'
        ]

        @$().addClass colors[_.random 0, 17]

    actions:
        filter: (type) ->
            @set 'filterIsToday', false
            @set 'filterIsYesterday', false
            @set 'filterIsWeek', false
            @set 'filterIsMonth', false
            @set "filterIs#{type.charAt(0).toUpperCase() + type.slice 1}", true
