'use strict'

###
Factory in the drtool.
@name drTool.Todo
###
angular.module('drTool')
.factory 'Todo', (Restangular) ->

  Restangular.service 'todos'
