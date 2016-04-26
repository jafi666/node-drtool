'use strict'

###
Controller of the drtool.
Home controller contains functions for managing main page.
###
angular.module('drTool')
.controller 'HomeController',
['$scope', '$location', ($scope, $location) ->
  $scope.peopleList = [{name:'Jafeth Garcia'}]

  $scope.person = {}
  $scope.dt = ''
  $scope.generateDaily = (isValid) ->
    if isValid
      $location.path 'daily'
      console.log($scope.person)
]