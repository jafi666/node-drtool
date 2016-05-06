'use strict'

###
Controller of the drtool.
Home controller contains functions for managing main page.
###
angular.module('drTool')
.controller 'HomeController',
['$scope', '$location', 'People', ($scope, $location, People) ->
  People.getList()
  .then (people) ->
    $scope.peopleList = people

  $scope.person = {}
  $scope.dt = ''
  $scope.generateDaily = (isValid) ->
    if isValid
      $location.path 'daily'
      console.log($scope.person)
]