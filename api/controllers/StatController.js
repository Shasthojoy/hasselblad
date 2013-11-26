/*
StatController

@module      :: Controller
@description    :: A set of functions called `actions`.

Actions contain code telling Sails how to respond to a certain type of request.
(i.e. do stuff, then send some JSON, show an HTML page, or redirect to another URL)

You can configure the blueprint URLs which trigger these actions (`config/controllers.js`)
and/or override them with custom routes (`config/routes.js`)

NOTE: The code you write here supports both HTTP and Socket.io automatically.

@docs        :: http://sailsjs.org/#!documentation/controllers
*/

module.exports = {
  index: function(req, res) {
    sails.log.info('StatController index action...');
    var filterBy = null;

    if(req.query !== null) {
      filterBy = req.query.filter;
    } else if(req.body !== null) {
      filterBy = req.body.filter;
    }

    Stat.find().done(function(err, stats) {
      if(err) return res.send(err, 500);

      _.forEach(stats, function(stat) {
        stat.snapshots = stat.filterSnapshots(filterBy);
      });

      return res.json(stats);
    });
  },

  /*
      Overrides for the settings in `config/controllers.js`
      (specific to StatController)
  */
  _config: {
    blueprints: {
      actions: true,
      rest: true,
      shortcuts: false
    }
  }
};
