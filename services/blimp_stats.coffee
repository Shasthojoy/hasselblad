_ = require 'lodash'
moment = require 'moment'
moment_range = require 'moment-range'
Stats = require('../services/stats')


class BlimpStats extends Stats
    constructor: (@service) ->

    getStats: (cb, statStore, dateFrom, dateTo) ->
        @service.getData ((data) ->

            from = moment(dateFrom)
            to = moment(dateTo)
            current = from

            async.whilst (->
                current.isBefore(to)
            ), ((callback) ->
                nextDate = moment(current).add('hours', 1)
                range = moment_range().range(current, nextDate)

                stats = {}

                async.parallel [
                    (parallelCallback) =>
                        _users = _.filter data.users, (user) ->
                            moment_range(user.date_joined).within range

                        _projects = _.filter data.projects, (project) ->
                            moment_range(project.date_created).within range

                        results =
                            blimp:
                                users: _users.length
                                projects: _projects.length

                        _.assign stats, results
                        parallelCallback()
                ], (err) ->
                    return callback(err) if (err)
                    console.log stats
                    statStore.save current.toDate(), stats, (documents) ->
                        console.log '-----------------'
                        return callback()

                current.add("hours", 1)
            ), (err) ->
                return cb(err) if (err)
                return cb()

        ), dateFrom, dateTo

module.exports = BlimpStats

