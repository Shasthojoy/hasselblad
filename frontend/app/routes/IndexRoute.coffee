module.exports = App.IndexRoute = Ember.Route.extend
  model: ->
    [{
        title: 'Users'
        value: 13
        lastUpdate: '3 mins ago'
    },
    {
        title: 'Companies'
        value: 4
        lastUpdate: '20 mins ago'
    }]
