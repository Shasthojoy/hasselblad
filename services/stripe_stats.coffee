Stats = require './stats'

_ = require 'lodash'
moment = require 'moment'
moment_range = require 'moment-range'


class StripeStats extends Stats
    constructor: (@service) ->

    getStats: (cb, statStore, dateFrom, dateTo) ->
        @service.getData (data) ->
            to = new Date dateTo
            from = new Date dateFrom
            stats = {}
            current = moment dateFrom

            async.whilst ->
                current.isBefore moment to
            , (callback) ->
                range = moment().range from, moment(current).add 'd', 1
                async.parallel [
                    (parallelCallback) =>
                        customers = _.filter data, (customer) ->
                            moment(new Date customer.created * 1000).within range
                        results = stripe: customers: customers.length
                        _.assign stats, results
                        parallelCallback()
                ], (err) ->
                    return callback(err) if (err)
                    console.log stats
                    statStore.save current.toDate(), stats, (documents) ->
                        console.log '-----------------'
                        return callback()
                current.add 'd', 1
            , (err) ->
                return cb(err) if (err)
                return cb()
        , dateFrom, dateTo

module.exports = StripeStats

