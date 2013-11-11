async = require('async')
_ = require('lodash')

class StatStore
    constructor: (@statModel) ->

    save: (date, stats=[], cb) ->
        hasselbladStats = []
        modifiedDocuments = []

        for serviceName in _.keys(stats)
            serviceStats = stats[serviceName]

            for statName in _.keys(serviceStats)
                serviceStatName = "#{serviceName}_#{statName}"
                snapshot =
                    value: serviceStats[statName]
                    date: date

                hasselbladStats.push
                    name: serviceStatName
                    snapshots: [snapshot]

        async.each hasselbladStats, (stat, callback) =>
            @statModel.findByName(stat.name).done (err, documents) =>
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
                        snapshots: stat.snapshots
                    ).done (err, documents) ->
                        return callback(err) if err
                        modifiedDocuments.push.apply(modifiedDocuments, documents)
                        callback()
        , (err) ->
            cb(modifiedDocuments)


module.exports = StatStore