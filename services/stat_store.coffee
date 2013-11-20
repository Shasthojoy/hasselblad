async = require('async')
_ = require('lodash')

class StatStore
    constructor: (@statModel) ->

    save: (serviceName, date, stats=[], cb) ->
        hasselbladStats = []
        modifiedDocuments = []

        for statName in _.keys(stats)
            snapshot =
                value: stats[statName]
                date: date

            hasselbladStats.push
                name: statName
                snapshots: [snapshot]

        async.each hasselbladStats, (stat, callback) =>
            criteria =
                name: stat.name
                service: serviceName

            @statModel.find(criteria).done (err, documents) =>
                return callback(err) if err

                if documents.length == 1
                    document = documents[0]
                    document.snapshots.push.apply(document.snapshots, stat.snapshots)

                    document.save (err) ->
                        return callback(err) if err
                        modifiedDocuments.push(document)
                        callback()

                else if documents.length == 0
                    @statModel.create(
                        name: stat.name
                        service: serviceName
                        snapshots: stat.snapshots
                    ).done (err, documents) ->
                        return callback(err) if err
                        modifiedDocuments.push.apply(modifiedDocuments, documents)
                        callback()
        , (err) ->
            cb(modifiedDocuments)


module.exports = StatStore