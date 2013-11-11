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

    moment = require("moment")
    a = moment("2013-11-10")
    b = moment("2013-11-11")
    m = a

    async.whilst (->
        m.isBefore(b)
    ), ((callback) ->
        date = m.format("YYYY-MM-DD HH:mm:ss")

        nextDate = moment(date).add('hours', 1).format("YYYY-MM-DD HH:mm:ss")

        stats = {}

        async.parallel [
            (parallelCallback) =>
                blimpStats.getStats ((results) ->
                    _.assign stats, results
                    parallelCallback()
                ), date, nextDate
        ], (err) ->
            return callback(err) if (err)
            statStore.save m.toDate(), stats, (documents) ->
                return callback()

        m.add("hours", 1)
    ), (err) ->
        return cb(err) if (err)
        return cb()
