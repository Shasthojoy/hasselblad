module.exports = App.StatsRoute = Ember.Route.extend
    model: ->
        @store.find 'stat'
