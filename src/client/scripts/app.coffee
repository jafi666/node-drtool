'use strict'

###
Main module of the application.
###
angular
  .module('drTool', [
    'ui.router'
    'ui.bootstrap'
    'restangular'
  ])
  .config ($urlRouterProvider, $stateProvider) ->

    $urlRouterProvider.otherwise '/home'

    $stateProvider
      .state 'home',
        url: '/home'
        templateUrl: 'partials/home.html'
        controller: 'HomeController'

  .config (RestangularProvider) ->
    RestangularProvider.setRestangularFields { id: "_id" }

  .constant "TABS",
    options: [
      name: 'Projects'
      ref: 'projects'
    ]
    filters: [
      {
        name: 'All projects'
        value: ''
        key: ''
      }
    ]

  .constant "HELPER",
    result = {}