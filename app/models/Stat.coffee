module.exports = App.Stat = DS.Model.extend
    name: DS.attr 'string'
    service: DS.attr 'string'
    snapshots: DS.attr()

    filterBy: (filter) ->
        console.log filter

    filtered: (->
        console.log 'filtered', arguments
    ).observes 'filter'
