Stripe = require('stripe')(require('../local').stripe)
Service = require './service'

class StripeService extends Service
    getData: (cb, dateFrom, dateTo) ->
        options = created: {}

        if dateFrom? or dateTo?
            dateTo ?= dateFrom if dateFrom?
            options.created.lte = new Date(dateFrom).getTime()
            options.created.gte = new Date(dateTo).getTime()

        Stripe.customers.list (err, customers) ->
            if err? then cb(err) else cb(customers.data)

module.exports = StripeService
