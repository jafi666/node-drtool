'use strict'

###
Factory in the deviceSimulatorApp.
@name deviceSimulatorApp.socketSimulator
###
angular.module('deviceSimulatorApp')
  .factory 'socketSimulator', ($rootScope) ->
    socket = null
    hostName = document.location.hostname
    eventKey = 'simualtor'

    return result =

      ###
      Removes listeners, if socket has not been instanced it create ones.
      ###
      reconnect: ->
        if socket?
          socket.removeAllListeners()
        socket = io.connect 'http://' + hostName

      ###
      Wrapper of Sockect.on.
      @param eventName [String] socket name.
      @param callback [Function] function to be executed after socket receives an events.
      ###
      on: (eventName, callback) ->
        socket.on eventName, ->
          args = arguments
          $rootScope.$apply ->
            callback.apply socket, args
