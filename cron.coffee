async = require 'async'
_ = require 'lodash'
moment = require 'moment'
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

    a = moment("2013-01-01")
    b = moment("2013-11-12")
    aDate = a.format("YYYY-MM-DD HH:mm:ss")
    bDate = b.format("YYYY-MM-DD HH:mm:ss")

    blimpStats.getStats cb, statStore, aDate, bDate
