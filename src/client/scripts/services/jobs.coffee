'use strict'

###
Factory in the deviceSimulatorApp.
@name deviceSimulatorApp.LinkedStacks
###
angular.module('deviceSimulatorApp')
  .factory 'LinkedStacks', (Restangular) ->

    Restangular.service 'jobs'
