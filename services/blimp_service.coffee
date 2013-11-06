Service = require('../services/service')
Sequelize = require("sequelize")
async = require('async')


class BlimpService extends Service
    constructor: (database, username, password) ->
        @sequelize = new Sequelize database, username, password,
            dialect: "postgres"

    getData: (cb) ->
        results = {}

        async.parallel [
            (callback) =>
                @sequelize.query("SELECT * FROM auth_user;").success (rows) ->
                    results.users = rows
                    callback()
        ,   (callback) =>
                @sequelize.query("SELECT * FROM core_project;").success (rows) ->
                    results.projects = rows
                    callback()
        ], (err) ->
            return cb(results)

module.exports = BlimpService
