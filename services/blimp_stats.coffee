Stats = require('../services/stats')

class BlimpStats extends Stats
    constructor: (@service) ->

    getStats: (cb) ->
        @service.getData ((data) ->

            stats =
                blimp:
                    users: data.users.length
                    projects: data.projects.length

            cb(stats)
        ), '2013-10-01', '2013-11-07'

module.exports = BlimpStats
