module.exports = App.ApplicationAdapter = DS.RESTAdapter.extend
    init: ->
        @_super()

    pathForType: (type) ->
        @type = type
        return type

    ajax: (url, method, hash) ->
        adapter = this

        new Ember.RSVP.Promise (resolve, reject) ->
            hash = hash || {}

            hash.callback = (obj) ->
                unless Ember.isNone obj.status
                    Ember.run null, reject, obj
                else
                    result = {}
                    result[adapter.type] = obj
                    Ember.run null, resolve, result

            socket.request url, hash.data, hash.callback, method.toLowerCase()
