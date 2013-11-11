Stats = require('../services/stats')

class BlimpStats extends Stats
    constructor: (@service) ->

    getStats: (cb, dateFrom, dateTo) ->
        @service.getData ((data) ->

            stats =
                blimp:
                    users: data.users.length
                    projects: data.projects.length

            cb(stats)
        ), dateFrom, dateTo

module.exports = BlimpStats
