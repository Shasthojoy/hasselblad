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

                @sequelize.query("SELECT * FROM auth_user#{$where} ORDER BY date_joined;").success (rows) ->
                    results.users = rows
                    callback()
        ,   (callback) =>
                if dateFrom?
                    $where = " WHERE date_created >= '#{dateFrom}' AND date_created <= '#{dateTo}'"

                @sequelize.query("SELECT * FROM core_company#{$where} ORDER BY date_created;").success (rows) ->
                    results.companies = rows
                    callback()
        ,   (callback) =>
                if dateFrom?
                    $where = " WHERE date_created >= '#{dateFrom}' AND date_created <= '#{dateTo}'"

                @sequelize.query("SELECT * FROM core_project#{$where} ORDER BY date_created;").success (rows) ->
                    results.projects = rows
                    callback()
        ,   (callback) =>
                if dateFrom?
                    $where = " WHERE date_created >= '#{dateFrom}' AND date_created <= '#{dateTo}'"

                @sequelize.query("SELECT * FROM core_todo#{$where} ORDER BY date_created;").success (rows) ->
                    results.todos = rows
                    callback()
        ,   (callback) =>
                if dateFrom?
                    $where = " WHERE date_created >= '#{dateFrom}' AND date_created <= '#{dateTo}'"

                @sequelize.query("SELECT * FROM core_list#{$where} ORDER BY date_created;").success (rows) ->
                    results.lists = rows
                    callback()
        ,   (callback) =>
                if dateFrom?
                    $where = " WHERE date_created >= '#{dateFrom}' AND date_created <= '#{dateTo}'"

                @sequelize.query("SELECT * FROM core_file#{$where} ORDER BY date_created;").success (rows) ->
                    results.files = rows
                    callback()
        ,   (callback) =>
                if dateFrom?
                    $where = " WHERE date_created >= '#{dateFrom}' AND date_created <= '#{dateTo}'"

                @sequelize.query("SELECT * FROM discussions_message#{$where} ORDER BY date_created;").success (rows) ->
                    results.discussions = rows
                    callback()
        ], (err) ->
            return cb(err) if (err)
            return cb(results)

module.exports = BlimpService
