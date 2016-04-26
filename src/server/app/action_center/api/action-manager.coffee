# node modules
Q = require 'q'
mongoose = require 'mongoose'

###

###
class ActionManager
  ###

  ###
  constructor: (modelName) ->
    @model = mongoose.model modelName

  ###

  ###
  findAll: ->
    deferred = Q.defer()
    @model.find (error, data) ->
      unless error
        deferred.resolve data
      else
        deferred.reject error
    deferred.promise

  ###

  ###
  findOne: (id) ->
    deferred = Q.defer()
    @model.findById id, (error, data) ->
      unless error
        deferred.resolve data
      else
        deferred.reject error
    deferred.promise

  ###

  ###
  create: (object) ->
    deferred = Q.defer()
    @model.create object, (error, data) ->
      unless error
        deferred.resolve data
      else
        deferred.reject error
    deferred.promise


module.exports = ActionManager