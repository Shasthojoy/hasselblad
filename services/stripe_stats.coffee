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
            range = moment().range from, to

            customers = _.filter data, (customer) ->
                moment(new Date customer.created * 1000).within range

            results = stripe: customers: customers.length
            console.log results
            statStore.save from, _.assign({}, results), (docs) ->
                console.log '-----------------'
                cb()
        , dateFrom, dateTo

module.exports = StripeStats

