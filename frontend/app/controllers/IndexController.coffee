module.exports = App.IndexController = Ember.ArrayController.extend
    filterBy: (filter) ->
        console.log filter

    actions:
        filter: ->
            console.log this
            @filterBy 'today'
            @set 'filter', 'something'
