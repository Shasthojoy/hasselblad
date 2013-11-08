module.exports = Ember.Handlebars.registerBoundHelper 'stat-total', (snapshots) ->
    total = 0
    total += stat.value for stat in snapshots
    total


