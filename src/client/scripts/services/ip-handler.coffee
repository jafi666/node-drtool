'use strict'

###
Factory in the deviceSimulatorApp.
@name deviceSimulatorApp.IpHandler
###
angular.module('deviceSimulatorApp')
  .factory 'IpHandler', (Restangular) ->

    Restangular.service 'iphandler'
