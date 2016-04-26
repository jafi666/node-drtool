# Node modules
q = require 'q'
mongoose = require 'mongoose'
glob = require 'glob'
path = require 'path'

module.exports = (config) ->

  result =
    getDBURL: ->
      dbHost = config.host
      dbPort = config.port
      dbName = config.name
      "mongodb://#{dbHost}:#{dbPort}/#{dbName}"

    connect: ->
      deferred = q.defer()
      mongoose.connect @getDBURL()
      db = mongoose.connection
      db.once 'open', ->
        deferred.resolve()
      db.on 'error', ->
        error = new Error 'unable to connect to database'
        deferred.reject error
      deferred.promise

    start: ->
      @connect()

    _loadModels: ->
      models = glob.sync path.join __dirname, './models/*.js'
      models.forEach (modelPath) ->
        require(modelPath)

  result._loadModels()

  result
