Service = require('../services/service')
Sequelize = require("sequelize")
async = require('async')


class BlimpService extends Service
    constructor: (db) ->
        @sequelize = new Sequelize db.database, db.username, db.password,
            dialect: "postgres"
            maxConcurrentQueries: 100
            pool:
                maxConnections: 5
                maxIdleTime: 30

    getData: (cb, dateFrom, dateTo) ->
        dateTo ?= dateFrom if dateFrom?
        $where = ''
        results = {}

        async.parallel [
            (callback) =>
                if dateFrom?
                    $where = " WHERE date_joined >= '#{dateFrom}' AND date_joined <= '#{dateTo}'"

                @sequelize.query("SELECT * FROM auth_user#{$where};").success (rows) ->
                    results.users = rows
                    callback()
        ,   (callback) =>
                if dateFrom?
                    $where = " WHERE date_created >= '#{dateFrom}' AND date_created <= '#{dateTo}'"

                @sequelize.query("SELECT * FROM core_project#{$where};").success (rows) ->
                    results.projects = rows
                    callback()
        ], (err) ->
            return cb(err) if (err)
            return cb(results)

module.exports = BlimpService
