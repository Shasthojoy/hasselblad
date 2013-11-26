module.exports = App.Router.map ->
    @resource 'stats'
    @resource 'stat', path: 'stats/:stat_id', ->
        @route 'today', path: '?filter=today'
        @route 'yesterday', path: '?filter=yesterday'
        @route 'week', path: '?filter=week'
        @route 'month', path: '?filter=month'
