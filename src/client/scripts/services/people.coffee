'use strict'

###
Factory in the drtool.
@name drTool.Person
###
angular.module('drTool')
.factory 'People', (Restangular) ->

  Restangular.service 'people'
