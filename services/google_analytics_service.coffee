Service = require './service'

GA = require 'googleanalytics'
util = require 'util'
moment = require 'moment'

class GoogleAnalyticsService extends Service
    constructor: (user, password, @profile) ->
        @ga = new GA.GA
            user: user
            password: password

    getData: (cb, dateFrom, dateTo) ->
        @ga.login (err, token) =>
            metrics = ['ga:pageviews', 'ga:visitors', 'ga:newVisits']

            options =
                ids: "ga:#{@profile}"
                sort: 'ga:date'
                metrics: metrics.join ','
                dimensions: 'ga:date'

            if dateFrom? or dateTo?
                dateTo ?= dateFrom if dateFrom?
                options['end-date'] = moment(new Date dateTo).format 'YYYY-MM-DD'
                options['start-date'] = moment(new Date dateFrom).format 'YYYY-MM-DD'

            @ga.get options, (err, entries) ->
                # util.debug(JSON.stringify(entries))
                if err? then cb(err) else cb(entries)

module.exports = GoogleAnalyticsService
