module.exports = App.IndexRoute = Ember.Route.extend
  model: ->
    [{
        title: 'Users'
        stats: [{
            value: 13
            lastUpdate: '2013-01-01'
        }, {
            value: 2
            lastUpdate: '2013-01-02'
        }, {
            value: 30
            lastUpdate: '2013-01-03'
        }, {
            value: 19
            lastUpdate: '2013-01-04'
        }]
    },
    {
        title: 'Companies'
        stats: [{
            value: 2
            lastUpdate: '2013-01-01'
        }, {
            value: 7
            lastUpdate: '2013-01-02'
        }, {
            value: 3
            lastUpdate: '2013-01-03'
        }, {
            value: 12
            lastUpdate: '2013-01-04'
        }]
    }]
