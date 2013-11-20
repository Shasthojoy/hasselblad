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
                nextDate = moment(current).add('d', 1)
                range = moment_range().range(current, nextDate)

                stats = {}

                async.parallel [
                    (parallelCallback) =>
                        _users = _.filter data.users, (user) ->
                            moment_range(user.date_joined).within range

                        _active_users = _.filter data.active_users, (user) ->
                            moment_range(user.last_login).within range

                        _companies = _.filter data.companies, (company) ->
                            moment_range(company.date_created).within range

                        _projects = _.filter data.projects, (project) ->
                            moment_range(project.date_created).within range

                        _todos = _.filter data.todos, (todo) ->
                            moment_range(todo.date_created).within range

                        _lists = _.filter data.lists, (list) ->
                            moment_range(list.date_created).within range

                        _files = _.filter data.files, (file) ->
                            moment_range(file.date_created).within range

                        _discussions = _.filter data.discussions, (discussion) ->
                            moment_range(discussion.date_created).within range

                        results =
                            blimp:
                                users: _users.length
                                active_users: _active_users.length
                                projects: _projects.length
                                companies: _companies.length
                                todos: _todos.length
                                lists: _lists.length
                                files: _files.length
                                discussions: _discussions.length

                        _.assign stats, results
                        parallelCallback()
                ], (err) ->
                    return callback(err) if (err)
                    console.log stats
                    statStore.save current.toDate(), stats, (documents) ->
                        console.log '-----------------'
                        return callback()

                current.add("d", 1)
            ), (err) ->
                return cb(err) if (err)
                return cb()
        ), dateFrom, dateTo

module.exports = BlimpStats

