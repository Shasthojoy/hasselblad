module.exports = App.IndexRoute = Ember.Route.extend
    model: ->
        @store.findQuery 'stat',
            filter: 'today'

    setupController: (controller, stat) ->
        controller.set 'model', stat
