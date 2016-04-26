'use strict'

###
Factory in the deviceSimulatorApp.
@name deviceSimulatorApp.socket
###
angular.module('deviceSimulatorApp')
  .factory 'socket', ($rootScope) ->
    socket = null
    hostName = document.location.hostname
    eventKey = 'event-generator-'

    return result =

      ###
      Removes listeners and create it again before the view is changed.
      ###
      reconnect: ->
        if socket?
          socket.removeAllListeners eventKey + 'log'
          socket.removeAllListeners eventKey + 'end'
        socket = io.connect 'http://' + hostName

      ###
      Wrapper of Sockect.on.
      @param eventName [String] socket name.
      @param callback [Function] function to be executed after socket receives an events.
      ###
      on: (eventName, callback) ->
        socket.on eventKey + eventName, ->
          args = arguments
          $rootScope.$apply ->
            callback.apply socket, args
