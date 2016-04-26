# Node modules
glob = require 'glob'
path = require 'path'

# Own modules
config = require '../config/config'
DataPersistence = (require './data_persistence')(config.db)
ActionCenter = require './action_center'

# Constants
routesPath = 'routes/api/*.js'
ONE = 1
THREE = 3
ZERO = 0

###
Loading every routes or REST api available.
@param app [Express] an instance of express app.
@param dbConfig [Object] data base configuration.
@param express [Express] node module.
###
module.exports = (app, express) ->
  DataPersistence.connect()
  .then ->
    console.log 'done!'

  actionCenter = new ActionCenter
  fullRoutesPath = path.join __dirname, routesPath
  apiRoutes = glob.sync fullRoutesPath
  apiRoutes.forEach (reoutePath) ->
    actionName = buildActionName reoutePath
    action = actionCenter.getAction actionName
    require(reoutePath)(app, express, action)

###
buils a action's name.
@param routePath [String] file's path.
###
buildActionName = (routePath) ->
  arrayActionName = routePath.split '/'
  positionName = arrayActionName.length - ONE
  actionName = arrayActionName[positionName]
  lengthName = actionName.length - THREE
  actionName = actionName.slice ZERO, lengthName