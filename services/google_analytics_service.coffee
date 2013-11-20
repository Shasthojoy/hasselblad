local = require '../local'
Service = require './service'

GA = require 'googleanalytics'
util = require 'util'
moment = require 'moment'

class GoogleAnalyticsService extends Service
    getData: (cb, dateFrom, dateTo) ->
        ga = new GA.GA
            user: local.googleUser
            password: local.googlePassword

        ga.login (err, token) ->
            metrics = ['ga:pageviews', 'ga:visitors', 'ga:newVisits']

            options =
                ids: "ga:#{local.googleProfile}"
                sort: 'ga:date'
                metrics: metrics.join ','
                dimensions: 'ga:date'

            if dateFrom? or dateTo?
                dateTo ?= dateFrom if dateFrom?
                options['end-date'] = moment(new Date dateTo).format 'YYYY-MM-DD'
                options['start-date'] = moment(new Date dateFrom).format 'YYYY-MM-DD'

            ga.get options, (err, entries) ->
                # util.debug(JSON.stringify(entries))
                if err? then cb(err) else cb(entries)

module.exports = GoogleAnalyticsService
