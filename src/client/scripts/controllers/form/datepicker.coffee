'use strict'

###
Controller of the drtool.
Home controller contains functions for managing main page.
###
angular.module('drTool')
.controller 'DatePickerController',
['$scope', ($scope) ->
  $scope.today = ->
    $scope.person.date = new Date()

  $scope.today()

  $scope.clear = ->
    $scope.person.date = null

  $scope.inlineOptions =
    customClass: getDayClass
    minDate: new Date()
    showWeeks: true

  $scope.dateOptions =
    dateDisabled: disabled
    formatYear: 'yy'
    maxDate: new Date(2020, 5, 22)
    minDate: new Date()
    startingDay: 1

  # Disable weekend selection
  disabled = (data) ->
    date = data.date
    mode = data.mode
    mode == 'day' && (date.getDay() == 0 || date.getDay() == 6)

  $scope.toggleMin = ->
    $scope.inlineOptions.minDate = $scope.inlineOptions.minDate ? null : new Date()
    $scope.dateOptions.minDate = $scope.inlineOptions.minDate

  $scope.toggleMin()

  $scope.open1 = ->
    $scope.popup1.opened = true

  $scope.open2 = ->
    $scope.popup2.opened = true

  $scope.setDate = (year, month, day) ->
    $scope.person.date = new Date(year, month, day)

  $scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate']
  $scope.format = $scope.formats[0]
  $scope.altInputFormats = ['M!/d!/yyyy']

  $scope.popup1 =
    opened: false

  $scope.popup2 =
    opened: false

  tomorrow = new Date()
  tomorrow.setDate(tomorrow.getDate() + 1)
  afterTomorrow = new Date()
  afterTomorrow.setDate(tomorrow.getDate() + 1)
  $scope.events = [
    {
      date: tomorrow
      status: 'full'
    },
    {
      date: afterTomorrow
      status: 'partially'
    }
  ]

  getDayClass = (data) ->
    date = data.date
    mode = data.mode
    if mode == 'day'
      dayToCheck = new Date(date).setHours(0,0,0,0)

      for event in $scope.events
        currentDay = new Date(event.date).setHours(0,0,0,0)

        if dayToCheck == currentDay
          event.status
]
