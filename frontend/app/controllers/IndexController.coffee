module.exports = App.IndexController = Ember.ArrayController.extend
    init: ->
        console.log this

    filterBy: (filter) ->
        console.log filter, ':O'

    actions:
        filter: ->
            console.log this
            @filterBy 'tits'
            @set 'filter', 'something'
