module.exports = App.Router.map ->
    @resource 'stats'
    @resource 'stat', {path: 'stats/:stat_id'}
