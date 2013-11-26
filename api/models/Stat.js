/*
Stat

@module      :: Model
@description :: A short summary of how this model works and what it represents.
@docs       :: http://sailsjs.org/#!documentation/models
*/

var moment = require("moment");

module.exports = {
  attributes: {
    name: {
      type: "string",
      required: true
    },
    service: {
      type: "string",
      required: true
    },
    snapshots: "array",

    // Filter a stats's snapshots array
    filterSnapshots: function(filterBy) {
      var filterFuntion;

      switch(filterBy) {
        case 'today':
          filterFunction = function(snapshot) {
            var today = moment().format('YYYY-MM-DD');
            return moment(snapshot.date).format('YYYY-MM-DD') === today;
          };
          break;
        case 'yesterday':
          filterFunction = function(snapshot) {
            var yesterday = moment().subtract('days', 1).format('YYYY-MM-DD');
            return moment(snapshot.date).format('YYYY-MM-DD') === yesterday;
          };
          break;
        case 'week':
          filterFunction = function(snapshot) {
            var lastWeek = moment().subtract('week', 1).format('YYYY-MM-DD'),
              date = moment(snapshot.date).format('YYYY-MM-DD');
            return moment(date).isAfter(lastWeek);
          };
          break;
        case 'month':
          filterFunction = function(snapshot) {
            var lastMonth = moment().subtract('month', 1).format('YYYY-MM-DD'),
              date = moment(snapshot.date).format('YYYY-MM-DD');
            return moment(date).isAfter(lastMonth);
          };
          break;
        default:
          filterFunction = function() {
            return true;
          };
      }

      return _.filter(this.snapshots, filterFunction);
    }

  }
};
