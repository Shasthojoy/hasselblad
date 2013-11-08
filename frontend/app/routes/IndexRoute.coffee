module.exports = App.IndexRoute = Ember.Route.extend
    model: -> @store.find 'stat'

    setupController: (controller, stat) ->
        console.log arguments, @model()
        controller.set 'model', stat
