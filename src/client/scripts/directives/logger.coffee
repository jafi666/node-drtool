'use strict'

###
Directive for selecting the datetime
@name deviceSimulatorApp.directive:deviceDatepicker
###
angular.module('deviceSimulatorApp')
.directive 'ngLogger', ['$http',
($http) ->

  # Default template
  TEMPLATE = [
    '<div ng-if="logger.length">'
    '  <div style="clear: both;"></div>'
    '  <div class="logger">'
    '    <div class="header">'
    '      <h3>Log</h3>'
    '    </div>'
    '    <textarea rows="15">{{logger.join("\r")}}</textarea>'
    '  </div>'
    '</div>'
  ].join ''

  {
    restrict: 'A'
    template: TEMPLATE
    scope:
      logger: '=ngLogger'
  }
]
