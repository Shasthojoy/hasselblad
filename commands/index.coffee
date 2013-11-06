Waterline = require('waterline')
adapter = require('sails-mongo')
config = require('../config/adapters')
cron = require('../cron')


module.exports =
    services: (done) ->
        cron.startCron global.sails, done

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
                done()
