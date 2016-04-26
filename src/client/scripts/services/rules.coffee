'use strict'

###
Factory in the deviceSimulatorApp.
@name deviceSimulatorApp.Rules
###
angular.module('deviceSimulatorApp')
  .factory 'Rules', (Restangular) ->

    Restangular.service 'rules'
