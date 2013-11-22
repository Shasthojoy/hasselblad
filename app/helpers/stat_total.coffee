module.exports = Ember.Handlebars.registerBoundHelper 'stat-total', (snapshots) ->
    total = 0
    total += snapshot.get('value') for snapshot in snapshots
    total


