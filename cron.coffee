_ = require 'lodash'
async = require 'async'
moment = require 'moment'

local = require './local'
StatStore = require './services/stat_store'
BlimpStats = require './services/blimp_stats'
BlimpService = require './services/blimp_service'
StripeStats = require './services/stripe_stats'
StripeService = require './services/stripe_service'

exports.startCron = (sails, cb) ->
    db =
        database: 'blimp'
        username: local.dbUser
        password: local.dbPass

    a = moment '2013-11-01'
    b = moment '2013-11-20'
    aDate = a.format 'YYYY-MM-DD HH:mm:ss'
    bDate = b.format 'YYYY-MM-DD HH:mm:ss'

    StatStore = new StatStore sails.models.stat

    BlimpService = new BlimpService db
    BlimpStats = new BlimpStats BlimpService

    StripeService = new StripeService()
    StripeStats = new StripeStats StripeService

    async.parallel [
        ( (callback) -> StripeStats.getStats callback, StatStore, aDate, bDate),
        ( (callback) -> BlimpStats.getStats callback, StatStore, aDate, bDate)
    ], ->
        console.log 'DONE'
        cb()
