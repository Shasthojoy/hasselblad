async = require('async')
_ = require('lodash')
BlimpService = require('./services/blimp_service')
BlimpStats = require('./services/blimp_stats')
StatStore = require('./services/stat_store')


exports.startCron = (sails, cb) ->
    blimpService = new BlimpService('blimp', 'jpadilla', '')
    blimpStats = new BlimpStats(blimpService)
    statStore = new StatStore(sails.models.stat)

    stats = {}

    async.parallel [
        (callback) =>
            blimpStats.getStats (results) ->
                _.assign stats, results
                callback()
    ], (err) ->
        statStore.save stats, (documents) ->
            return cb(documents)
