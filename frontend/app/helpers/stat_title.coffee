module.exports = Ember.Handlebars.registerBoundHelper 'stat-title', (str) ->
    arr = str.split '_'
    "#{arr[0].capitalize()} #{arr[1].capitalize()}"


