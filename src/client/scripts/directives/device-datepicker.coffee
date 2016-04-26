'use strict'

###
Directive for selecting the datetime
@name deviceSimulatorApp.directive:deviceDatepicker
###
angular.module('deviceSimulatorApp')
.directive 'deviceDatepicker', ['$http', '$compile', '$interval', '$filter', 'Restangular',
($http, $compile, $interval, $filter, Restangular) ->

  # Initialize constants
  HEIGHT = 232
  HEIGHT_MIN = 80
  SECONDS = 20000

  # Default template
  TEMPLATE = [
    '<div>'
    '  <div class="icon icon-time" ng-click="expand()">'
    '  </div>'
    '  <div class="dir-datepicker">'
    '    <div class="dir-title" ng-click="expand()">{{device.time | date:\'H:mm\'}}</div>'
    '    <div class="dir-body">'
    '    </div>'
    '  </div>'
    '</div>'
  ].join ''

  {
    template: TEMPLATE,
    replace: true,
    scope:
      device: '=deviceDatepicker'
    link: (scope, domElement, attrs, ngModel) ->
      card = domElement.closest 'div.card'

      ###
      Updates the UI timer
      @private
      ###
      _timer = ->
        scope.device.time += SECONDS

      # Real-time timer
      $interval _timer, SECONDS

      # UI form to pich the datetime.
      scope.expand = ->
        html = [
          '<form ng-submit="saveDatepicker(item)">'
          '  <div class="label">Date</div>'
          '  <input type="date" ng-model="item.day" min="2000-01-01" max="2036-12-31" required/>'
          '  <div class="label">Time</div>'
          '  <input type="time" ng-model="item.time" required/>'
          '  <div class="options-container">'
          '    <input type="submit" class="btn-accept" name="Save">'
          '    <input type="button" ng-click="cancel()" class="btn-cancel" value="Cancel">'
          '  </div>'
          '</form>'
        ].join ''
        scope.compile html
        card.height HEIGHT
        _setDefaultDate()
        return

      ###
      Gets day and time from UI.
      ###
      scope.saveDatepicker = (item) ->
        datetime = scope.buildTime item.day, item.time
        scope.device.time = datetime.getTime()

        Restangular.one('settime', scope.device._id).post null, scope.device
        .then null, (error) ->
          alert error.data.error

        scope.compile ''
        card.height HEIGHT_MIN
        return

      ###
      Handles cancel button's event from UI.
      ###
      scope.cancel = ->
        scope.compile ''
        card.height HEIGHT_MIN
        return

      ###
      Buils a Date object from strings.
      @param day [String] date as string with 'yyyy-mm-dd' format.
      @param time [String] time as string with '23:59:59' format.
      @throw Day is undefined
      @throw Time is undefined
      ###
      scope.buildTime = (day, time) ->
        unless day?
          throw new Error 'Day is undefined'
        unless time?
          throw new Error 'Time is undefined'

        day = day.split '-'
        time = time.split ':'
        new Date day[0], day[1] - 1, day[2], time[0], time[1]

      ###
      Compiles HTML string and append it to UI.
      @param html [String] should be HTML as string.
      @example
      html = '<div>Hi!</div>'
      ###
      scope.compile = (html) ->
        element = angular.element '<div/>'
        element.append html
        $compile(element) scope
        className = '.dir-body'
        domElement.find(className).empty()
        domElement.find(className).append element

      ###
      Sets device's time to datepicker form
      @private
      ###
      _setDefaultDate = ->
        scope.item =
          day: $filter('date') scope.device.time, "yyyy-MM-dd"
          time: $filter('date') scope.device.time, "HH:mm"
  }
]
