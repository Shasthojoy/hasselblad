Stats = require './stats'

_ = require 'lodash'
util = require 'util'
moment = require 'moment'
moment_range = require 'moment-range'


class GoogleAnalyticsStats extends Stats
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
                        items = _.filter data, (item) ->
                            d = item.dimensions[0]['ga:date']
                            date = "#{d.substring(0,4)} #{d.substring(4,6)} #{d.substring(6,8)}"
                            moment(new Date date).within range

                        snapshot = _.find items, (item) ->
                            moment(current).add('d', 1).format('YYYYMMDD') is item.dimensions[0]['ga:date']

                        results =
                            views: snapshot.metrics[0]['ga:pageviews']
                            visitors: snapshot.metrics[0]['ga:visitors']
                            minutes_on_app: _.parseInt snapshot.metrics[0]['ga:timeOnSite'] * 0.0166667
                            unique_visitors: snapshot.metrics[0]['ga:newVisits']

                        _.assign stats, results
                        parallelCallback()
                ], (err) ->
                    return callback(err) if (err)
                    console.log stats
                    statStore.save 'google_analytics', current.toDate(), stats, (documents) ->
                        console.log '-----------------'
                        return callback()
                current.add 'd', 1
            , (err) ->
                return cb(err) if (err)
                return cb()
        , dateFrom, dateTo

module.exports = GoogleAnalyticsStats

