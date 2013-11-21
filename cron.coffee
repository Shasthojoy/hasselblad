_ = require 'lodash'
async = require 'async'
moment = require 'moment'

local = require './local'
StatStore = require './services/stat_store'
BlimpStats = require './services/blimp_stats'
BlimpService = require './services/blimp_service'
StripeStats = require './services/stripe_stats'
StripeService = require './services/stripe_service'
GoogleAnalyticsStats = require './services/google_analytics_stats'
GoogleAnalyticsService = require './services/google_analytics_service'

exports.startCron = (sails, cb) ->
    db =
        database: 'blimp'
        username: local.dbUser
        password: local.dbPass

    googleUser = local.googleUser
    googlePassword = local.googlePassword
    googleProfile = local.googleProfile

    a = moment '2013-11-01'
    b = moment '2013-11-21'
    aDate = a.format 'YYYY-MM-DD HH:mm:ss'
    bDate = b.format 'YYYY-MM-DD HH:mm:ss'

    StatStore = new StatStore sails.models.stat

    BlimpService = new BlimpService db
    BlimpStats = new BlimpStats BlimpService

    StripeService = new StripeService local.stripe
    StripeStats = new StripeStats StripeService

    GoogleAnalyticsService = new GoogleAnalyticsService googleUser, googlePassword, googleProfile
    GoogleAnalyticsStats = new GoogleAnalyticsStats GoogleAnalyticsService

    async.parallel [
        ( (callback) -> GoogleAnalyticsStats.getStats callback, StatStore, aDate, bDate),
        ( (callback) -> StripeStats.getStats callback, StatStore, aDate, bDate),
        ( (callback) -> BlimpStats.getStats callback, StatStore, aDate, bDate)
    ], ->
        console.log 'DONE'
        cb()
