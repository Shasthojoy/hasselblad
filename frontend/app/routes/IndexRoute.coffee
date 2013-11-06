module.exports = App.IndexRoute = Ember.Route.extend
    model: ->
        @store.find 'stat'
