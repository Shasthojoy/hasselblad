moment = require("moment")

###
StatController

@module      :: Controller
@description    :: A set of functions called `actions`.

Actions contain code telling Sails how to respond to a certain type of request.
(i.e. do stuff, then send some JSON, show an HTML page, or redirect to another URL)

You can configure the blueprint URLs which trigger these actions (`config/controllers.js`)
and/or override them with custom routes (`config/routes.js`)

NOTE: The code you write here supports both HTTP and Socket.io automatically.

@docs        :: http://sailsjs.org/#!documentation/controllers
###

module.exports =

    index: (request, response) ->
        sails.log.info('StatControler index action...')

        now = moment()
        nowFormatted = now.format('YYYY-MM-DD')
        filter = request.query?.filter || request.body?.filter

        Stat.find().done (err, stats) ->
            return res.send(err, 500) if err

            _.forEach stats, (stat) ->
                stat.snapshots = _.filter stat.snapshots, (snapshot) ->
                    if filter is 'today'
                        moment(snapshot.date).format('YYYY-MM-DD') is nowFormatted
                    else
                        snapshot is snapshot
            console.log stats
            response.json(stats)



    ###
    Overrides for the settings in `config/controllers.js`
    (specific to StatController)
    ###
    _config:
        blueprints:
            actions: true
            rest: false