Service = require('../services/service')
Sequelize = require("sequelize")
async = require('async')


class BlimpService extends Service
    constructor: (db) ->
        @sequelize = new Sequelize db.database, db.username, db.password,
            dialect: "postgres"

    getData: (cb, dateFrom, dateTo) ->
        dateTo ?= dateFrom if dateFrom?
        $where = ''
        results = {}

        async.parallel [
            (callback) =>
                if dateFrom?
                    $where = " WHERE date_joined BETWEEN '#{dateFrom}' AND '#{dateTo}'"

                @sequelize.query("SELECT * FROM auth_user#{$where};").success (rows) ->
                    results.users = rows
                    callback()
        ,   (callback) =>
                if dateFrom?
                    $where = " WHERE date_created BETWEEN '#{dateFrom}' AND '#{dateTo}'"

                @sequelize.query("SELECT * FROM core_project#{$where};").success (rows) ->
                    results.projects = rows
                    callback()
        ], (err) ->
            return cb(results)

module.exports = BlimpService
