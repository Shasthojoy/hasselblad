_ = require 'lodash'
async = require 'async'
moment = require 'moment'

StatStore = require './services/stat_store'
BlimpStats = require './services/blimp_stats'
BlimpService = require './services/blimp_service'
StripeStats = require './services/stripe_stats'
StripeService = require './services/stripe_service'
GoogleAnalyticsStats = require './services/google_analytics_stats'
GoogleAnalyticsService = require './services/google_analytics_service'

exports.startCron = (sails, cb) ->
    a = moment '2013-11-01'
    b = moment '2013-11-21'
    aDate = a.format 'YYYY-MM-DD HH:mm:ss'
    bDate = b.format 'YYYY-MM-DD HH:mm:ss'

    if process.env.NODE_ENV is 'production'
        match = process.env.BLIMP_DATABASE_URL
        .match(/postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/)

        db =
            database: match[5]
            username: match[1]
            password: match[2]
            host: match[3]
            port: match[4]

        googleUser = process.env.GOOGLE_ANALYTICS_USER
        googlePassword = process.env.GOOGLE_ANALYTICS_PASSWORD
        googleProfile = process.env.GOOGLE_ANALYTICS_PROFILE

        stripeApiKey = process.env.STRIPE_API_KEY
    else
        local = require './local'

        db =
            database: 'blimp'
            username: local.dbUser
            password: local.dbPass
            host: 'localhost'
            port: 5432

        googleUser = local.googleUser
        googlePassword = local.googlePassword
        googleProfile = local.googleProfile

        stripeApiKey = local.stripe

    StatStore = new StatStore sails.models.stat

    BlimpService = new BlimpService db
    BlimpStats = new BlimpStats BlimpService

    StripeService = new StripeService stripeApiKey
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
