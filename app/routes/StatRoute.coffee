module.exports = App.StatRoute = Ember.Route.extend
    model: (params) ->
        @store.find 'stat', params.stat_id
