async = require 'async'
_ = require 'lodash'
BlimpService = require './services/blimp_service'
BlimpStats = require './services/blimp_stats'
StatStore = require './services/stat_store'
local = require './local'

exports.startCron = (sails, cb) ->
    db =
        database: 'blimp'
        username: local.dbUser
        password: local.dbPass

    blimpService = new BlimpService(db)
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
