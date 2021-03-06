# ===== Config =====

# Swag Config
Swag.Config.partialsPath = 'templates/'
Swag.registerHelpers()

window.App = require 'config/app'
require 'config/router'
require 'config/store'
require 'config/adapter'

# To test data binding
window.App.dataTest = {}

# Load all modules in order automagically. Ember likes things to work this
# way so everything is in the App.* namespace.
folderOrder = [
  'initializers', 'mixins', 'routes', 'models', 'views', 'controllers',
  'helpers', 'templates', 'components'
]

folderOrder.forEach (folder) ->
  # Go through the prefixes in order and rquire them
  window.require.list().filter((module) ->
    new RegExp("^#{folder}/").test(module)
  ).forEach((module) -> require(module))
