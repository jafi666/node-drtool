'use strict'

###
Factory in the deviceSimulatorApp.
@name deviceSimulatorApp.Device
###
angular.module('deviceSimulatorApp')
  .factory 'Device', (Restangular) ->

    Restangular.service 'devices'
