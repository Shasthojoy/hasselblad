Waterline = require('waterline')
adapter = require('sails-mongo')
config = require('../config/adapters')

module.exports =
    testCommand: (done) ->
        adapter.config = config.adapters.mongo

        Collection = Waterline.Collection.extend
            adapter: 'mongo'
            tableName: 'stat'

        new Collection
            adapters:
                mongo: adapter
        , (err, collection) ->
            collection.find().done (err, collection) ->
                console.log collection

            Stat.find().done (err, stats) ->
                console.log stats
                done()
